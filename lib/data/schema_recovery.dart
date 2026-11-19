import 'dart:io';

import 'package:sqlite3/sqlite3.dart' as sqlite;

void unlockDatabase(sqlite.Database database, String hexKey) {
  if (database.select('PRAGMA cipher').isEmpty) {
    throw StateError('Encrypted SQLite is unavailable');
  }
  database.execute("PRAGMA cipher = 'chacha20'");
  // The key is hex-encoded random bytes, which cannot alter the pragma.
  database.execute("PRAGMA key = '$hexKey'");
  database.select('SELECT count(*) FROM sqlite_schema');
}

/// Saves the encrypted main database while SQLite excludes concurrent writers.
void protectLedgerMigration(
  sqlite.Database source,
  File file,
  String hexKey,
  int version,
) {
  final checkpoint = source.select('PRAGMA wal_checkpoint(TRUNCATE)').single;
  if (checkpoint['busy'] != 0) {
    throw StateError('Could not checkpoint the ledger');
  }
  source.execute('BEGIN IMMEDIATE');
  try {
    final wal = File('${file.path}-wal');
    if (wal.existsSync() && wal.lengthSync() != 0) {
      throw StateError('Ledger changed during migration preparation');
    }
    final backup = File('${file.path}.v$version.backup');
    if (backup.existsSync()) {
      _verifySnapshot(backup, hexKey, version);
      return;
    }
    final staging = file.parent.createTempSync('ledger-migration-');
    try {
      final copy = file.copySync('${staging.path}/ledger.sqlite');
      final handle = copy.openSync(mode: FileMode.append);
      try {
        handle.flushSync();
      } finally {
        handle.closeSync();
      }
      _verifySnapshot(copy, hexKey, version);
      copy.renameSync(backup.path);
    } finally {
      staging.deleteSync(recursive: true);
    }
  } finally {
    source.execute('ROLLBACK');
  }
}

void _verifySnapshot(File file, String hexKey, int version) {
  final database = sqlite.sqlite3.open(
    file.path,
    mode: sqlite.OpenMode.readOnly,
  );
  try {
    unlockDatabase(database, hexKey);
    if (database.select('PRAGMA user_version').single.values.single !=
            version ||
        database.select('PRAGMA integrity_check').single.values.single !=
            'ok') {
      throw StateError('Could not verify the encrypted migration copy');
    }
  } finally {
    database.close();
  }
}
