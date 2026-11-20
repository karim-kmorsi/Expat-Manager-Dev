import 'dart:io';

import 'package:flutter/services.dart';

import 'database.dart';
import 'ledger_backup.dart';

const _storage = MethodChannel('com.karimkmorsi.expat_manager/storage');
const _documents = MethodChannel('com.karimkmorsi.expat_manager/backup');

Future<({File file, Uint8List key})> _localKey([String? recoveryId]) async {
  final storage = await _storage.invokeMapMethod<String, Object>(
    recoveryId == null ? 'openLedger' : 'openRecoveryLedger',
    recoveryId,
  );
  if (storage case {'path': final String path, 'key': final Uint8List key}) {
    // Platform channel byte lists are not guaranteed to be writable.
    return (file: File(path), key: Uint8List.fromList(key));
  }
  throw const StorageLocked();
}

Future<LedgerDatabase> openAndroidLedger() async {
  final local = await _localKey();
  final db = await LedgerDatabase.open(local.file, local.key);
  try {
    await finishPendingRestore(db, local.file.parent);
    return db;
  } catch (_) {
    await db.close();
    throw const StorageLocked();
  }
}

Future<LedgerBackup> androidLedgerBackup(LedgerDatabase live) async {
  final local = await _localKey();
  local.key.fillRange(0, local.key.length, 0);
  return LedgerBackup(
    live: live,
    privateDirectory: local.file.parent,
    openRecovery: (file) async {
      final root = await _localKey();
      return LedgerDatabase.open(file, root.key, auxiliary: true);
    },
    reopenLive: () async {
      final current = await _localKey();
      return LedgerDatabase.open(current.file, current.key, auxiliary: true);
    },
  );
}

Future<Uint8List?> chooseBackupDocument() =>
    _documents.invokeMethod<Uint8List>('import');

Future<bool> saveBackupDocument(Uint8List bytes) async =>
    await _documents.invokeMethod<bool>('export', bytes) ?? false;

Future<void> protectBackupPassword(bool protect) =>
    _documents.invokeMethod<void>('protectPassword', protect);

Future<PreparedRestore> prepareAndroidRecovery(
  Uint8List file,
  Uint8List password,
) async {
  try {
    final path = await _storage.invokeMethod<String>('recoveryDirectory');
    if (path == null) throw const StorageLocked();
    return await prepareBackup(Directory(path), file, password);
  } finally {
    password.fillRange(0, password.length, 0);
  }
}

Future<void> recoverAndroidLedger(PreparedRestore prepared) async {
  final id = await _storage.invokeMethod<String>('createRecoveryLedger');
  if (id == null) throw const StorageLocked();
  final local = await _localKey(id);
  final database = await LedgerDatabase.open(local.file, local.key);
  try {
    final service = LedgerBackup(
      live: database,
      privateDirectory: local.file.parent,
      openRecovery: (file) async {
        final key = await _localKey(id);
        return LedgerDatabase.open(file, key.key, auxiliary: true);
      },
      reopenLive: () async {
        final latest = await _localKey(id);
        return LedgerDatabase.open(latest.file, latest.key, auxiliary: true);
      },
    );
    await service.restore(prepared);
  } finally {
    await database.close();
  }
  await _storage.invokeMethod<void>('activateRecoveryLedger', id);
}
