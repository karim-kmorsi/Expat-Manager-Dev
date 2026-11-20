import 'dart:io';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

import 'backup_envelope.dart';
import 'backup_snapshot.dart';
import 'database.dart';

typedef OpenLedgerFile = Future<LedgerDatabase> Function(File file);

class PreparedRestore {
  PreparedRestore._(this._snapshot);

  BackupSnapshot? _snapshot;

  BackupSnapshot get preview =>
      _snapshot ?? (throw const BackupException(BackupIssue.invalidData));

  void discard() => _snapshot = null;

  BackupSnapshot _consume() {
    final snapshot = preview;
    discard();
    return snapshot;
  }
}

class LedgerBackup {
  LedgerBackup({
    required this.live,
    required this.privateDirectory,
    required this.openRecovery,
    required this.reopenLive,
  });

  final LedgerDatabase live;
  final Directory privateDirectory;
  final OpenLedgerFile openRecovery;
  final Future<LedgerDatabase> Function() reopenLive;
  bool _restoring = false;
  bool _requiresReopen = false;

  Future<Uint8List> export(Uint8List password) async {
    Uint8List? bytes;
    try {
      _checkReady();
      final snapshot = await live.transaction(() => BackupSnapshot.read(live));
      bytes = snapshot.encode();
      return await encryptBackup(bytes, password);
    } finally {
      if (bytes != null) bytes.fillRange(0, bytes.length, 0);
      password.fillRange(0, password.length, 0);
    }
  }

  Future<PreparedRestore> prepare(Uint8List file, Uint8List password) async {
    try {
      _checkReady();
      return await prepareBackup(privateDirectory, file, password);
    } finally {
      password.fillRange(0, password.length, 0);
    }
  }

  Future<void> restore(PreparedRestore prepared) async {
    _checkReady();
    final imported = prepared._consume();
    _restoring = true;
    var committed = false;
    try {
      final id = await _newRestoreId();
      final rollback = Directory(
        '${privateDirectory.path}/restore-rollback-$id',
      );
      await rollback.create();
      await live.transaction(() async {
        final previous = await BackupSnapshot.read(live);
        final path = File('${rollback.path}/ledger.sqlite');
        final snapshot = await openRecovery(path);
        try {
          await snapshot.transaction(() => previous.replace(snapshot));
        } finally {
          await snapshot.close();
        }
        final verification = await openRecovery(path);
        try {
          await validateRestoredLedger(verification);
          if (!previous.matches(await BackupSnapshot.read(verification))) {
            throw const BackupException(BackupIssue.invalidData);
          }
        } finally {
          await verification.close();
        }
        await imported.replace(live);
        await validateRestoredLedger(live);
        await live.customStatement('''
          CREATE TABLE IF NOT EXISTS local_restore_state (
            id INTEGER PRIMARY KEY CHECK (id = 1),
            restore_id TEXT NOT NULL
          )
        ''');
        await live.customStatement(
          'INSERT OR REPLACE INTO local_restore_state VALUES (1, ?)',
          [id],
        );
      });
      committed = true;
      final reopened = await reopenLive();
      try {
        await reopened.transaction(() async {
          await validateRestoredLedger(reopened);
          if (await _restoreMarker(reopened) != id ||
              !imported.matches(await BackupSnapshot.read(reopened))) {
            throw const BackupException(BackupIssue.invalidData);
          }
        });
      } finally {
        await reopened.close();
      }
      await _retire(rollback);
    } on Object {
      if (committed) {
        // The marker and the complete new state are already durable. Do not
        // invite a retry or permit interaction until a new open validates it.
        _requiresReopen = true;
        throw const BackupException(BackupIssue.recoveryPending);
      }
      throw const BackupException(BackupIssue.invalidData);
    } finally {
      _restoring = false;
    }
  }

  void _checkReady() {
    if (_restoring || _requiresReopen) {
      throw const BackupException(BackupIssue.recoveryPending);
    }
  }
}

Future<PreparedRestore> prepareBackup(
  Directory privateDirectory,
  Uint8List file,
  Uint8List password,
) async {
  Uint8List? data;
  Directory? staging;
  Uint8List? key;
  LedgerDatabase? stage;
  try {
    data = await decryptBackup(file, password);
    final sodium = await SodiumInit.init();
    key = sodium.randombytes.buf(32);
    staging = await privateDirectory.createTemp('restore-staging-');
    final path = File('${staging.path}/ledger.sqlite');
    final initial = await LedgerDatabase.open(
      path,
      Uint8List.fromList(key),
      auxiliary: true,
    );
    stage = initial;
    final backup = BackupSnapshot.decode(data, initial);
    await initial.transaction(
      () => backup.replace(
        initial,
        prepareLegacy: backup.schema != initial.schemaVersion,
      ),
    );
    stage = null;
    await initial.close();
    final migrated = await LedgerDatabase.open(
      path,
      Uint8List.fromList(key),
      auxiliary: true,
    );
    stage = migrated;
    await validateRestoredLedger(migrated);
    return PreparedRestore._(await BackupSnapshot.read(migrated));
  } on BackupException {
    rethrow;
  } on Object {
    throw const BackupException(BackupIssue.invalidData);
  } finally {
    if (data != null) data.fillRange(0, data.length, 0);
    if (key != null) key.fillRange(0, key.length, 0);
    password.fillRange(0, password.length, 0);
    try {
      await stage?.close();
    } finally {
      if (staging != null) await _retire(staging);
    }
  }
}

Future<String> _newRestoreId() async {
  final sodium = await SodiumInit.init();
  return sodium.bin2hex(sodium.randombytes.buf(16));
}

Future<String?> _restoreMarker(LedgerDatabase db) async {
  final table = await db
      .customSelect(
        "SELECT 1 FROM sqlite_schema WHERE type='table' AND name='local_restore_state'",
      )
      .getSingleOrNull();
  if (table == null) return null;
  return (await db
          .customSelect('SELECT restore_id FROM local_restore_state WHERE id=1')
          .getSingleOrNull())
      ?.read<String>('restore_id');
}

/// A prior process may have stopped after commit and before retiring its copy.
Future<void> finishPendingRestore(
  LedgerDatabase db,
  Directory directory,
) async {
  final id = await _restoreMarker(db);
  if (id == null) return;
  if (!RegExp(r'^[0-9a-f]{32}$').hasMatch(id)) {
    throw const BackupException(BackupIssue.invalidData);
  }
  final rollback = Directory('${directory.path}/restore-rollback-$id');
  if (!await rollback.exists()) return;
  await db.transaction(() => validateRestoredLedger(db));
  await _retire(rollback);
}

Future<void> _retire(Directory directory) async {
  try {
    await directory.delete(recursive: true);
  } on FileSystemException {
    // A retained private encrypted copy is safe. Never report a failed
    // transaction after validation just because cleanup could not complete.
  }
}
