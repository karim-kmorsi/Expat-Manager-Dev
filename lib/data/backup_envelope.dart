import 'dart:convert';
import 'dart:typed_data';
import 'dart:isolate';

import 'package:sodium/sodium_sumo.dart';

const maxBackupBytes = 16 * 1024 * 1024;
const _magic = 'EXPMBACK';
const _version = 1;

enum BackupIssue {
  unsupported,
  invalidPassword,
  invalidData,
  tooLarge,
  recoveryPending,
}

class BackupException implements Exception {
  const BackupException(this.issue);
  final BackupIssue issue;
}

typedef _CryptoInput = ({Uint8List bytes, Uint8List password});

Future<Uint8List> encryptBackup(Uint8List data, Uint8List password) =>
    _runCrypto(_encrypt, data, password);

Future<Uint8List> decryptBackup(Uint8List data, Uint8List password) =>
    _runCrypto(_decrypt, data, password);

Future<Uint8List> _runCrypto(
  Future<Uint8List> Function(_CryptoInput) operation,
  Uint8List data,
  Uint8List password,
) async {
  try {
    if (password.isEmpty || password.length > 1024) {
      throw const BackupException(BackupIssue.invalidPassword);
    }
    if (data.length > maxBackupBytes) {
      throw const BackupException(BackupIssue.tooLarge);
    }
    return await Isolate.run(
      () => operation((bytes: data, password: password)),
    );
  } finally {
    password.fillRange(0, password.length, 0);
  }
}

SecureKey _derive(SodiumSumo sodium, Uint8List password, Uint8List salt) =>
    sodium.crypto.pwhash.callRaw(
      outLen: sodium.crypto.secretStream.keyBytes,
      password: Int8List.view(
        password.buffer,
        password.offsetInBytes,
        password.length,
      ),
      salt: salt,
      opsLimit: 2,
      memLimit: 64 * 1024 * 1024,
      alg: CryptoPwhashAlgorithm.argon2id13,
    );

Future<Uint8List> _encrypt(_CryptoInput input) async {
  SecureKey? key;
  try {
    final sodium = await SodiumSumoInit.init();
    final stream = sodium.crypto.secretStream;
    final salt = sodium.randombytes.buf(sodium.crypto.pwhash.saltBytes);
    final prefix = Uint8List.fromList([
      ...ascii.encode(_magic),
      _version,
      ...salt,
    ]);
    if (prefix.length +
            stream.headerBytes +
            input.bytes.length +
            stream.aBytes >
        maxBackupBytes) {
      throw const BackupException(BackupIssue.tooLarge);
    }
    key = _derive(sodium, input.password, salt);
    final output = BytesBuilder(copy: false)..add(prefix);
    await for (final frame in stream.pushEx(
      messageStream: Stream.value(
        SecretStreamPlainMessage(
          input.bytes,
          additionalData: prefix,
          tag: SecretStreamMessageTag.finalPush,
        ),
      ),
      key: key,
    )) {
      output.add(frame.message);
    }
    return output.takeBytes();
  } finally {
    key?.dispose();
    input.password.fillRange(0, input.password.length, 0);
    input.bytes.fillRange(0, input.bytes.length, 0);
  }
}

Future<Uint8List> _decrypt(_CryptoInput input) async {
  SecureKey? key;
  try {
    final bytes = input.bytes;
    if (bytes.length <= _magic.length ||
        String.fromCharCodes(bytes.take(_magic.length)) != _magic ||
        bytes[_magic.length] != _version) {
      throw const BackupException(BackupIssue.unsupported);
    }
    final sodium = await SodiumSumoInit.init();
    final stream = sodium.crypto.secretStream;
    final saltOffset = _magic.length + 1;
    final prefixEnd = saltOffset + sodium.crypto.pwhash.saltBytes;
    final cipherOffset = prefixEnd + stream.headerBytes;
    if (bytes.length < cipherOffset + stream.aBytes) {
      throw const BackupException(BackupIssue.invalidData);
    }
    final prefix = Uint8List.sublistView(bytes, 0, prefixEnd);
    key = _derive(
      sodium,
      input.password,
      Uint8List.sublistView(bytes, saltOffset, prefixEnd),
    );
    final List<SecretStreamPlainMessage> frames;
    try {
      frames = await stream
          .pullEx(
            cipherStream: Stream.fromIterable([
              SecretStreamCipherMessage(
                Uint8List.sublistView(bytes, prefixEnd, cipherOffset),
              ),
              SecretStreamCipherMessage(
                Uint8List.sublistView(bytes, cipherOffset),
                additionalData: prefix,
              ),
            ]),
            key: key,
          )
          .toList();
    } on Exception {
      throw const BackupException(BackupIssue.invalidData);
    }
    if (frames.length != 1 ||
        frames.single.tag != SecretStreamMessageTag.finalPush) {
      for (final frame in frames) {
        frame.message.fillRange(0, frame.message.length, 0);
      }
      throw const BackupException(BackupIssue.invalidData);
    }
    // Return Dart-owned bytes; the worker isolate owns sodium's native buffers.
    final message = frames.single.message;
    final copy = Uint8List.fromList(message);
    message.fillRange(0, message.length, 0);
    return copy;
  } finally {
    key?.dispose();
    input.password.fillRange(0, input.password.length, 0);
  }
}
