import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expat_manager/data/database.dart';
import 'package:expat_manager/data/schema_recovery.dart';
import 'package:expat_manager/finance/ledger.dart';
import 'package:expat_manager/finance/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'support/financial_interruption_worker.dart' as worker;

void main() {
  if (!Platform.isLinux) return;
  late Directory directory;
  late String path;
  late Map<String, int> ids;
  late LedgerDatabase db;
  late Ledger ledger;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('expat-t011-recovery-');
    path = '${directory.path}/ledger.sqlite';
    db = await worker.openFailureFixture(path);
    ledger = Ledger(db);
    final bank = await ledger.createAccount(
      name: 'Synthetic Nepal bank',
      currency: 'USD',
      kind: AccountKind.bank,
    );
    final egypt = await ledger.createAccount(
      name: 'Synthetic Egypt bank',
      currency: 'EGP',
      kind: AccountKind.bank,
    );
    await ledger.recordOpening(
      operationId: 'baseline',
      accountId: bank,
      minor: 100000,
      effectiveAt: worker.fixtureDay,
    );
    ids = {
      'bank': bank,
      'wallet': await ledger.setupUsdCash(),
      'remittance': await ledger.planRemittance(
        operationId: 'baseline-remittance',
        sourceAccountId: bank,
        destinationAccountId: egypt,
        destinationCurrency: 'EGP',
        destination: RemittanceDestination.personal,
      ),
    };
  });

  tearDown(() async {
    await db.close();
    await directory.delete(recursive: true);
  });

  Future<void> reopen() async {
    await db.close();
    db = await worker.openFailureFixture(path);
    ledger = Ledger(db);
  }

  Future<Map<String, List<Map<String, Object?>>>> snapshot() async {
    final tables = await db.customSelect("""
      SELECT name FROM sqlite_schema WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
      ORDER BY name
    """).get();
    return {
      for (final row in tables)
        row.read<String>('name'): [
          for (final item
              in await db
                  .customSelect(
                    'SELECT * FROM "${row.read<String>('name')}" ORDER BY rowid',
                  )
                  .get())
            item.data,
        ],
    };
  }

  Future<void> integrity() async {
    expect(
      (await db.customSelect('PRAGMA integrity_check').getSingle())
          .data
          .values
          .single,
      'ok',
    );
    expect(await db.customSelect('PRAGMA foreign_key_check').get(), isEmpty);
    final unbalanced = await db.customSelect('''
      SELECT p.entry_id, a.currency FROM journal_postings p
      JOIN ledger_accounts a ON a.id = p.account_id
      GROUP BY p.entry_id, a.currency HAVING SUM(p.minor) <> 0
    ''').get();
    expect(unbalanced, isEmpty);
  }

  Future<void> interrupt(
    worker.FinancialWrite write, {
    bool committed = false,
  }) async {
    final flutterRoot = Platform.environment['FLUTTER_ROOT'];
    final dart = flutterRoot == null ? 'dart' : '$flutterRoot/bin/dart';
    final process = await Process.start(dart, [
      'run',
      'test/support/financial_interruption_worker.dart',
      path,
      write.name,
      jsonEncode(ids),
      committed ? 'committed' : 'staged',
    ]);
    final errors = process.stderr.transform(utf8.decoder).join();
    final ready = Completer<void>();
    final output = process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter());
    final subscription = output.listen((line) {
      if (line == 'FINANCIAL_WRITE_READY' && !ready.isCompleted) {
        ready.complete();
      }
    });
    try {
      final reached = await Future.any<bool>([
        ready.future.then((_) => true),
        process.exitCode.then((_) => false),
      ]).timeout(const Duration(seconds: 45));
      expect(reached, isTrue, reason: reached ? null : await errors);
      expect(process.kill(ProcessSignal.sigkill), isTrue);
      expect(await process.exitCode, -ProcessSignal.sigkill.signalNumber);
    } finally {
      process.kill(ProcessSignal.sigkill);
      await subscription.cancel();
      await process.stdin.close();
    }
  }

  for (final write in worker.FinancialWrite.values) {
    test('SIGKILL before outer commit: ${write.name}', () async {
      if (write == worker.FinancialWrite.remittanceReceipt) {
        await ledger.recordRemittanceEvent(
          remittanceId: ids['remittance']!,
          operationId: 'settlement-baseline',
          kind: RemittanceEventKind.debit,
          minor: 10000,
          effectiveAt: worker.fixtureDay,
          evidence: 'Synthetic debit',
        );
      }
      if (write == worker.FinancialWrite.correction) {
        ids['expense'] = await ledger.recordExpense(
          operationId: 'original-expense',
          input: (
            accountId: ids['bank']!,
            minor: 500,
            date: worker.fixtureDay,
            period: ExpensePeriod.individual,
            category: null,
            note: null,
          ),
        );
      }
      final before = await snapshot();
      await interrupt(write);
      await reopen();
      expect(await snapshot(), before);
      await integrity();
      final flushed = await worker.financialWrite(ledger, write, ids);
      final after = await snapshot();
      expect(after, isNot(before));
      await reopen();
      expect(await worker.financialWrite(ledger, write, ids), flushed);
      expect(await snapshot(), after);
      await integrity();
    }, timeout: const Timeout(Duration(minutes: 1)));
  }

  test(
    'SIGKILL after commit before response: salary retry is idempotent',
    () async {
      await interrupt(worker.FinancialWrite.salary, committed: true);
      await reopen();
      final saved = (await ledger.salaries()).single;
      final state = await snapshot();
      final retry = await worker.financialWrite(
        ledger,
        worker.FinancialWrite.salary,
        ids,
      );
      expect(retry, saved.id);
      expect((await ledger.balance(ids['bank']!)).minor, 300000);
      expect(await snapshot(), state);
      await integrity();
    },
    timeout: const Timeout(Duration(minutes: 1)),
  );
  test(
    'an insert failure after remittance postings leaves both sides intact',
    () async {
      for (final write in [
        worker.FinancialWrite.remittanceDebit,
        worker.FinancialWrite.remittanceReceipt,
      ]) {
        final before = await snapshot();
        await db.customStatement("""
        CREATE TRIGGER t011_reject_event BEFORE INSERT ON remittance_events
        BEGIN SELECT RAISE(ABORT, 'synthetic failure before event metadata'); END
      """);
        await expectLater(
          worker.financialWrite(ledger, write, ids),
          throwsA(isA<sqlite.SqliteException>()),
        );
        await reopen();
        expect(await snapshot(), before);
        await integrity();
        await db.customStatement('DROP TRIGGER t011_reject_event');
        // The debit becomes the baseline for the failure during receipt.
        if (write == worker.FinancialWrite.remittanceDebit) {
          await ledger.recordRemittanceEvent(
            remittanceId: ids['remittance']!,
            operationId: 'receipt-prerequisite',
            kind: RemittanceEventKind.debit,
            minor: 10000,
            evidence: 'Synthetic observed debit',
            effectiveAt: worker.fixtureDay,
          );
        } else {
          await worker.financialWrite(ledger, write, ids);
          expect(
            (await ledger.remittance(ids['remittance']!)).status,
            RemittanceStatus.received,
          );
        }
      }
    },
  );

  test(
    'a failed v4 upgrade retains the encrypted old data and retries safely',
    () async {
      // Start from a v4-shaped fixture with ledger data and force the v5
      // migration to fail after creating its tables and seeding one offset.
      await db.close();
      final hexKey = List.filled(
        32,
        worker.failureFixtureKey.toRadixString(16),
      ).join();
      List<Map<String, Object?>> oldPostings(sqlite.Database raw) => raw
          .select('SELECT * FROM journal_postings ORDER BY rowid')
          .map((row) => Map<String, Object?>.from(row))
          .toList();
      final old = sqlite.sqlite3.open(path);
      List<Map<String, Object?>> postings;
      try {
        unlockDatabase(old, hexKey);
        for (final table in [
          'remittance_family_payments',
          'remittance_purposes',
          'remittance_events',
          'remittances',
        ]) {
          old.execute('DROP TABLE $table');
        }
        old.execute(
          "DELETE FROM ledger_accounts WHERE kind IN ('remittanceExchange', 'remittanceTransit')",
        );
        old.execute('DROP INDEX system_account_by_currency');
        old.execute("""
        CREATE UNIQUE INDEX system_account_by_currency ON ledger_accounts (currency, kind)
        WHERE kind IN ('opening', 'income', 'expense', 'cashAdjustment')
      """);
        old.execute('PRAGMA user_version = 4');
        old.execute("""
        CREATE TRIGGER t011_fail_migration BEFORE INSERT ON ledger_accounts
        WHEN new.kind = 'remittanceExchange'
        BEGIN SELECT RAISE(ABORT, 'synthetic failure during migration'); END
      """);
        postings = oldPostings(old);
      } finally {
        old.close();
      }

      await expectLater(
        worker.openFailureFixture(path),
        throwsA(isA<StorageLocked>()),
      );

      final retained = sqlite.sqlite3.open(path);
      try {
        unlockDatabase(retained, hexKey);
        expect(retained.select('PRAGMA user_version').single.values.single, 4);
        expect(
          retained.select('PRAGMA integrity_check').single.values.single,
          'ok',
        );
        expect(retained.select('PRAGMA foreign_key_check'), isEmpty);
        expect(
          retained.select(
            "SELECT name FROM sqlite_schema WHERE name LIKE 'remittance%'",
          ),
          isEmpty,
        );
        expect(
          retained.select(
            "SELECT id FROM ledger_accounts WHERE kind LIKE 'remittance%'",
          ),
          isEmpty,
        );
        expect(oldPostings(retained), postings);
        retained.execute('DROP TRIGGER t011_fail_migration');
      } finally {
        retained.close();
      }
      final backup = sqlite.sqlite3.open(
        '$path.v4.backup',
        mode: sqlite.OpenMode.readOnly,
      );
      try {
        expect(
          () => backup.select('SELECT * FROM sqlite_schema'),
          throwsA(isA<sqlite.SqliteException>()),
        );
        unlockDatabase(backup, hexKey);
        expect(backup.select('PRAGMA user_version').single.values.single, 4);
        expect(oldPostings(backup), postings);
      } finally {
        backup.close();
      }

      db = await worker.openFailureFixture(path);
      ledger = Ledger(db);
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle())
            .data
            .values
            .single,
        5,
      );
      expect((await snapshot())['journal_postings'], postings);
      expect((await ledger.balance(ids['bank']!)).minor, 100000);
      await integrity();
    },
  );
}
