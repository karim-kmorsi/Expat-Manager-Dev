import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/ledger_backup.dart';

Future<void> main(List<String> args) async {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final file = File(args[0]);
  final committed = args[2] == 'after';
  Future<LedgerDatabase> open(File file) =>
      LedgerDatabase.open(file, Uint8List.fromList(List.filled(32, 2)));
  final live = await open(file);
  final service = LedgerBackup(
    live: live,
    privateDirectory: file.parent,
    openRecovery: open,
    reopenLive: () async {
      stdout.writeln('RESTORE_WRITE_READY');
      await stdout.flush();
      return Completer<LedgerDatabase>().future;
    },
  );
  final backup = await service.prepare(
    await File(args[1]).readAsBytes(),
    utf8.encode('sample-passphrase-123'),
  );
  if (committed) {
    await service.restore(backup);
  } else {
    // The outer transaction keeps the replacement and its marker uncommitted
    // while the worker is terminated by the parent test.
    await live.transaction(() => service.restore(backup));
  }
}
