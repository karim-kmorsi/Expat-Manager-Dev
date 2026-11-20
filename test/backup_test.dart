import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:expat_manager/data/backup_envelope.dart';
import 'package:expat_manager/data/backup_snapshot.dart';
import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/ledger_backup.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:expat_manager/leave/model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  const password = 'sample-passphrase-123';
  Uint8List pass([String value = password]) => utf8.encode(value);
  Uint8List key(int marker) => Uint8List.fromList(List.filled(32, marker));
  final date = DateTime.utc(2024, 6, 10);
  final day = leaveDay(date);
  late Directory temporary;
  late File sourceFile;
  late File targetFile;
  late LedgerDatabase source;
  late LedgerDatabase target;
  late LedgerBackup exports;
  late LedgerBackup imports;

  LedgerBackup service(
    File path,
    LedgerDatabase database,
    int marker, {
    OpenLedgerFile? rollback,
    Future<LedgerDatabase> Function()? reopen,
  }) => LedgerBackup(
    live: database,
    privateDirectory: path.parent,
    openRecovery: rollback ?? (file) => LedgerDatabase.open(file, key(marker)),
    reopenLive: reopen ?? () => LedgerDatabase.open(path, key(marker)),
  );

  Future<int> fixture(LedgerDatabase db, String name, int amount) async {
    final ledger = Ledger(db);
    final account = await ledger.createAccount(
      name: name,
      currency: 'USD',
      kind: AccountKind.bank,
    );
    await ledger.recordOpening(
      operationId: 'fixture-$name',
      accountId: account,
      minor: amount,
      effectiveAt: date,
    );
    return account;
  }

  Future<List<String>> accounts(LedgerDatabase db) async =>
      (await Ledger(db).accounts()).map((account) => account.name).toList();

  setUp(() async {
    temporary = await Directory.systemTemp.createTemp(
      'expat-protected-restore-',
    );
    sourceFile = File(
      '${(await Directory('${temporary.path}/source').create()).path}/ledger.sqlite',
    );
    targetFile = File(
      '${(await Directory('${temporary.path}/target').create()).path}/ledger.sqlite',
    );
    source = await LedgerDatabase.open(sourceFile, key(1));
    target = await LedgerDatabase.open(targetFile, key(2));
    exports = service(sourceFile, source, 1);
    imports = service(targetFile, target, 2);
  });

  tearDown(() async {
    await source.close();
    await target.close();
    await temporary.delete(recursive: true);
  });

  test(
    'restores a complete logical snapshot into a new encrypted vault',
    () async {
      final account = await fixture(source, 'Source fixture', 120000);
      final ledger = Ledger(source);
      final salary = await ledger.recordSalary(
        operationId: 'salary',
        accountId: account,
        minor: 170000,
        receivedOn: date,
      );
      await ledger.createSalaryPlan(salary);
      await ledger.addSalaryAllocation(salary, 'Donation fixture', 10000);
      final leave = await ledger.personalLeave.save(
        kind: LeaveKind.annual,
        status: LeaveStatus.approved,
        period: LeavePeriod(day, day + 1),
      );
      await ledger.saveTicket(
        year: date.year,
        expected: null,
        receivedDay: day,
        leaveId: leave,
      );
      await ledger.addGold(
        operationId: 'gold-fixture',
        details: const GoldDetails(
          label: 'Gold fixture',
          owner: 'Owner',
          kind: GoldKind.bar,
          weightMg: 500,
          karatHundredths: 2400,
        ),
        custodian: 'Custodian',
      );

      final clearPassword = pass();
      final bytes = await exports.export(clearPassword);
      expect(clearPassword.every((byte) => byte == 0), isTrue);
      expect(latin1.decode(bytes), isNot(contains('Source fixture')));
      expect(latin1.decode(bytes), isNot(contains(password)));
      expect(await exports.export(pass()), isNot(orderedEquals(bytes)));
      final prepared = await imports.prepare(bytes, pass());
      expect(prepared.preview.accounts, 1);
      expect(prepared.preview.leaveEntries, 1);
      expect(prepared.preview.goldPieces, 1);
      expect(await accounts(target), isEmpty);
      await imports.restore(prepared);
      expect(
        (await BackupSnapshot.read(target))
            .matches(await BackupSnapshot.read(source)),
        isTrue,
      );
      expect((await Ledger(target).balance(account)).minor, 290000);
      await expectLater(
        LedgerDatabase.open(targetFile, key(1)),
        throwsA(isA<StorageLocked>()),
      );
      expect(
        await targetFile.parent
            .list()
            .where(
              (e) =>
                  e is Directory &&
                  e.uri.pathSegments
                      .where((p) => p.isNotEmpty)
                      .last
                      .startsWith('restore-'),
            )
            .toList(),
        isEmpty,
      );
    },
  );

  test('cancelling preview leaves populated vault unchanged; confirmed restore replaces it', () async {
    await fixture(source, 'Backup values', 1000);
    await fixture(target, 'Existing values', 2000);
    final data = await exports.export(pass());
    final preview = await imports.prepare(data, pass());
    preview.discard();
    expect(await accounts(target), ['Existing values']);
    await imports.restore(await imports.prepare(data, pass()));
    expect(await accounts(target), ['Backup values']);
  });

  test('rejects wrong password, corruption, truncation, unknown format and oversized file', () async {
    await fixture(source, 'Portable fixture', 1000);
    await fixture(target, 'Live fixture', 2000);
    final valid = await exports.export(pass());
    Future<void> reject(Uint8List bytes, [String supplied = password]) =>
        expectLater(
          imports.prepare(bytes, pass(supplied)),
          throwsA(isA<BackupException>()),
        );
    await reject(valid, 'incorrect-passphrase');
    await reject(Uint8List.fromList(valid)..[valid.length - 1] ^= 1);
    await reject(
      Uint8List.fromList(valid)..[12] ^= 1,
    ); // Salt is authenticated.
    await reject(Uint8List.sublistView(valid, 0, valid.length - 8));
    await reject(Uint8List.fromList(valid)..[8] = 2);
    await reject(Uint8List(maxBackupBytes + 1));
    expect(await accounts(target), ['Live fixture']);
  });

  test('authentic data with orphaned or unbalanced postings is rejected in staging', () async {
    await fixture(source, 'Portable fixture', 1000);
    await fixture(target, 'Live fixture', 2000);
    Future<void> reject(void Function(Map<String, dynamic>) mutate) async {
      final value = jsonDecode(
        utf8.decode((await BackupSnapshot.read(source)).encode()),
      ) as Map<String, dynamic>;
      mutate(value);
      final invalid = await encryptBackup(
        utf8.encode(jsonEncode(value)),
        pass(),
      );
      await expectLater(
        imports.prepare(invalid, pass()),
        throwsA(isA<BackupException>()),
      );
      expect(await accounts(target), ['Live fixture']);
    }

    await reject((value) => value['schema'] = 999);
    await reject((value) => value['tables']['journal_postings'][0][1] = 9999);
    await reject((value) => value['tables']['journal_postings'][0][2] = 99);
    await reject(
      (value) => value['tables']['ledger_accounts'][0][3] = 'unknownKind',
    );
  });

  test(
    'rollback/open failures keep old values and skip the restore commit',
    () async {
      await fixture(source, 'Backup values', 1000);
      await fixture(target, 'Live values', 2000);
      final before = await BackupSnapshot.read(target);
      final diskFailure = service(
        targetFile,
        target,
        2,
        rollback: (file) async {
          throw const FileSystemException('Synthetic storage failure');
        },
      );
      final data = await exports.export(pass());
      final first = await diskFailure.prepare(data, pass());
      await expectLater(
        diskFailure.restore(first),
        throwsA(isA<BackupException>()),
      );
      expect((await BackupSnapshot.read(target)).matches(before), isTrue);

      await target.customStatement('''
      CREATE TRIGGER fixture_block_restore BEFORE INSERT ON journal_postings
      BEGIN SELECT RAISE(ABORT, 'fixture failure'); END
    ''');
      final ready = await imports.prepare(data, pass());
      await expectLater(
        imports.restore(ready),
        throwsA(isA<BackupException>()),
      );
      expect((await BackupSnapshot.read(target)).matches(before), isTrue);
      expect(await accounts(target), ['Live values']);
    },
  );

  test(
    'interruption after commit leaves complete new state and verified rollback',
    () async {
      await fixture(source, 'Backup values', 1000);
      await fixture(target, 'Live values', 2000);
      final serviceWithFailedReopen = service(
        targetFile,
        target,
        2,
        reopen: () async {
          throw const FileSystemException(
            'Synthetic restart before verification',
          );
        },
      );
      await expectLater(
        serviceWithFailedReopen.restore(
          await serviceWithFailedReopen.prepare(
            await exports.export(pass()),
            pass(),
          ),
        ),
        throwsA(
          isA<BackupException>().having(
            (e) => e.issue,
            'issue',
            BackupIssue.recoveryPending,
          ),
        ),
      );
      final rollback =
          (await targetFile.parent
                  .list()
                  .where((e) => e.path.contains('/restore-rollback-'))
                  .toList())
              .single;
      final snapshot = await LedgerDatabase.open(
        File('${rollback.path}/ledger.sqlite'),
        key(2),
      );
      try {
        expect(await accounts(snapshot), ['Live values']);
      } finally {
        await snapshot.close();
      }
      final reopened = await LedgerDatabase.open(targetFile, key(2));
      try {
        await finishPendingRestore(reopened, targetFile.parent);
        expect(
          (await BackupSnapshot.read(reopened))
              .matches(await BackupSnapshot.read(source)),
          isTrue,
        );
        expect(await rollback.exists(), isFalse);
      } finally {
        await reopened.close();
      }
    },
  );

  for (final committed in [false, true]) {
    test('SIGKILL ${committed ? 'after' : 'before'} restore commit', () async {
      await fixture(source, 'Backup values', 1000);
      await fixture(target, 'Live values', 2000);
      final backup = File('${temporary.path}/fixture.expbackup');
      await backup.writeAsBytes(await exports.export(pass()));
      await target.close();
      final flutterRoot = Platform.environment['FLUTTER_ROOT'];
      final dart = flutterRoot == null ? 'dart' : '$flutterRoot/bin/dart';
      final worker = await Process.start(dart, [
        'run',
        'test/support/restore_interruption_worker.dart',
        targetFile.path,
        backup.path,
        committed ? 'after' : 'before',
      ]);
      final errorText = worker.stderr.transform(utf8.decoder).join();
      final reached = Completer<void>();
      final output = worker.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
            if (line == 'RESTORE_WRITE_READY' && !reached.isCompleted) {
              reached.complete();
            }
          });
      try {
        final ready = await Future.any([
          reached.future.then((_) => true),
          worker.exitCode.then((_) => false),
        ]).timeout(const Duration(seconds: 45));
        expect(ready, isTrue, reason: ready ? null : await errorText);
        worker.kill(ProcessSignal.sigkill);
        expect(await worker.exitCode, -ProcessSignal.sigkill.signalNumber);
      } finally {
        worker.kill(ProcessSignal.sigkill);
        await output.cancel();
        await worker.stdin.close();
        target = await LedgerDatabase.open(targetFile, key(2));
      }
      await finishPendingRestore(target, targetFile.parent);
      expect(await accounts(target), [
        committed ? 'Backup values' : 'Live values',
      ]);
      final account = (await Ledger(target).accounts()).single;
      expect(
        (await Ledger(target).balance(account.id)).minor,
        committed ? 1000 : 2000,
      );
    }, skip: !Platform.isLinux);
  }

  const additions = [
    ['currencies', 'ledger_accounts', 'journal_entries', 'journal_postings'],
    [
      'salary_receipts',
      'salary_plans',
      'salary_allocations',
      'salary_executions',
      'movement_confirmations',
    ],
    ['cash_settings', 'cash_reconciliations'],
    ['expense_details'],
    [
      'remittances',
      'remittance_events',
      'remittance_purposes',
      'remittance_family_payments',
    ],
    ['leave_rules', 'leave_entries', 'leave_holidays'],
    ['dashain_plans', 'annual_tickets', 'travel_goals', 'travel_contributions'],
    ['gold_pieces', 'gold_sales', 'gold_events'],
  ];
  for (var version = 1; version <= 8; version++) {
    test('imports schema $version with stable IDs and balances', () async {
      final id = await fixture(source, 'Historical fixture', 19700);
      final decoded = jsonDecode(
        utf8.decode((await BackupSnapshot.read(source)).encode()),
      ) as Map<String, dynamic>;
      final existing = additions.take(version).expand((names) => names).toSet();
      (decoded['tables'] as Map).removeWhere(
        (key, _) => !existing.contains(key),
      );
      (decoded['sequences'] as Map).removeWhere(
        (key, _) => !existing.contains(key),
      );
      (decoded['tables']['ledger_accounts'] as List).removeWhere(
        (row) =>
            (version < 4 && row[3] == 'cashAdjustment') ||
            (version < 5 &&
                (row[3] == 'remittanceExchange' ||
                    row[3] == 'remittanceTransit')),
      );
      decoded['schema'] = version;
      final encrypted = await encryptBackup(
        utf8.encode(jsonEncode(decoded)),
        pass(),
      );
      final restored = await imports.prepare(encrypted, pass());
      await imports.restore(restored);
      expect((await Ledger(target).balance(id)).minor, 19700);
      expect(await accounts(target), ['Historical fixture']);
      expect(target.schemaVersion, 9);
    });
  }
}
