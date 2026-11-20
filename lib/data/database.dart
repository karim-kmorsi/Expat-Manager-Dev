import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sodium/sodium.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../finance/model.dart';
import '../leave/model.dart';
import 'schema_recovery.dart';

part 'database.g.dart';
part 'salary_tables.dart';
part 'cash_tables.dart';
part 'expense_tables.dart';
part 'remittance_tables.dart';
part 'leave_tables.dart';
part 'entitlement_tables.dart';

class Currencies extends Table {
  TextColumn get code => text()();
  IntColumn get scale => integer()();

  @override
  Set<Column<Object>> get primaryKey => {code};
}

class LedgerAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get currency => text().references(Currencies, #code)();
  TextColumn get kind => textEnum<AccountKind>()();
}

class JournalEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get operationId => text().unique()();
  TextColumn get kind => textEnum<JournalKind>()();
  IntColumn get effectiveMicros => integer()();
  IntColumn get openingAccountId =>
      integer().nullable().unique().references(LedgerAccounts, #id)();
  IntColumn get reversalOf =>
      integer().nullable().unique().references(JournalEntries, #id)();
  IntColumn get correctionOf =>
      integer().nullable().unique().references(JournalEntries, #id)();
  TextColumn get reason => text().nullable()();
}

class JournalPostings extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get accountId => integer().references(LedgerAccounts, #id)();
  IntColumn get minor => integer()();

  @override
  List<String> get customConstraints => [
    "CHECK (typeof(minor) = 'integer' AND minor BETWEEN -9223372036854775807 AND 9223372036854775807 AND minor <> 0)",
  ];

  @override
  Set<Column<Object>> get primaryKey => {entryId, accountId};
}

class StorageLocked implements Exception {
  const StorageLocked();
}

@DriftDatabase(
  tables: [
    Currencies,
    LedgerAccounts,
    JournalEntries,
    JournalPostings,
    SalaryReceipts,
    SalaryPlans,
    SalaryAllocations,
    SalaryExecutions,
    MovementConfirmations,
    CashSettings,
    CashReconciliations,
    ExpenseDetails,
    Remittances,
    RemittanceEvents,
    RemittancePurposes,
    RemittanceFamilyPayments,
    LeaveRules,
    LeaveEntries,
    LeaveHolidays,
    DashainPlans,
    AnnualTickets,
    TravelGoals,
    TravelContributions,
  ],
)
class LedgerDatabase extends _$LedgerDatabase {
  LedgerDatabase._(super.executor);

  static const _currentSchemaVersion = 7;

  /// Takes ownership of a writable copy of the key.
  static Future<LedgerDatabase> open(File file, Uint8List key) async {
    sqlite.Database? raw;
    LedgerDatabase? database;
    try {
      if (key.length != 32) throw const StorageLocked();
      final sodium = await SodiumInit.init();
      raw = sqlite.sqlite3.open(file.path);
      final hexKey = sodium.bin2hex(key);
      unlockDatabase(raw, hexKey);
      final version =
          raw.select('PRAGMA user_version').single.values.single as int;
      if (version > 0 && version < _currentSchemaVersion) {
        protectLedgerMigration(raw, file, hexKey, version);
      }
      raw.execute('PRAGMA journal_mode = WAL');
      raw.execute('PRAGMA synchronous = FULL');
      raw.execute('PRAGMA temp_store = MEMORY');
      raw.execute('PRAGMA foreign_keys = ON');
      database = LedgerDatabase._(NativeDatabase.opened(raw));
      await database.customSelect('SELECT 1').get();
      return database;
    } catch (_) {
      if (database != null) {
        await database.close();
      } else {
        raw?.close();
      }
      // SQLite errors can include the SQL statement that was executed.
      throw const StorageLocked();
    } finally {
      key.fillRange(0, key.length, 0);
    }
  }

  @override
  int get schemaVersion => _currentSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) => transaction(() async {
      if (from < 1 ||
          from >= _currentSchemaVersion ||
          to != _currentSchemaVersion) {
        throw StateError('Unsupported ledger schema');
      }
      if (from < 5) await _upgradeFinance(migrator, from);
      if (from < 6) {
        await migrator.createTable(leaveRules);
        await migrator.createTable(leaveEntries);
        await migrator.createTable(leaveHolidays);
        await _seedLeaveRules();
      }
      await migrator.createTable(dashainPlans);
      await migrator.createTable(annualTickets);
      await migrator.createTable(travelGoals);
      await migrator.createTable(travelContributions);
      await customStatement('PRAGMA user_version = $schemaVersion');
    }),
    onCreate: (migrator) => transaction(() async {
      await migrator.createAll();
      await _salaryIndexes();
      await customStatement(
        'CREATE INDEX journal_postings_by_account ON journal_postings (account_id)',
      );
      await customStatement(
        'CREATE INDEX journal_entries_by_date ON journal_entries (effective_micros, id)',
      );
      await _systemAccountIndex();
      for (final code in ['USD', 'NPR', 'EGP']) {
        await into(currencies).insert(Currency(code: code, scale: 2));
        for (final kind in [
          AccountKind.opening,
          AccountKind.income,
          AccountKind.expense,
        ]) {
          await into(ledgerAccounts).insert(
            LedgerAccountsCompanion.insert(
              name: kind.name,
              currency: code,
              kind: kind,
            ),
          );
        }
      }
      await _seedCash();
      await _seedAdjustmentAccounts();
      await _setupRemittances();
      await _seedLeaveRules();
      // Persist the version with the schema and seed rows on first open.
      await customStatement('PRAGMA user_version = $schemaVersion');
    }),
  );

  Future<void> _upgradeFinance(Migrator migrator, int from) async {
    if (from == 1) {
      for (final table in <TableInfo<Table, dynamic>>[
        salaryReceipts,
        salaryPlans,
        salaryAllocations,
        salaryExecutions,
        movementConfirmations,
      ]) {
        await migrator.createTable(table);
      }
      await _salaryIndexes();
    }
    if (from < 3) {
      await migrator.createTable(cashSettings);
      await migrator.createTable(cashReconciliations);
      await _seedCash();
    } else if (from == 3) {
      // Bank statements may show a negative observed balance. Cash remains
      // non-negative in the confirmed adjustment use case.
      await migrator.alterTable(TableMigration(cashReconciliations));
    }
    if (from < 4) {
      await migrator.createTable(expenseDetails);
      await _seedAdjustmentAccounts();
    }
    await migrator.createTable(remittances);
    await migrator.createTable(remittanceEvents);
    await migrator.createTable(remittancePurposes);
    await migrator.createTable(remittanceFamilyPayments);
    await customStatement('DROP INDEX system_account_by_currency');
    await _systemAccountIndex();
    await _setupRemittances();
  }

  Future<void> _seedLeaveRules() async {
    await into(leaveRules).insert(
      LeaveRule(
        effectiveDay: leaveDay(firstLeaveDate),
        annualDays: 30,
        casualDays: 13,
        sickDays: 15,
      ),
    );
  }

  Future<void> _systemAccountIndex() => customStatement(
    "CREATE UNIQUE INDEX system_account_by_currency ON ledger_accounts (currency, kind) "
    "WHERE kind IN ('opening', 'income', 'expense', 'cashAdjustment', 'remittanceTransit', 'remittanceExchange')",
  );

  Future<void> _seedCash() async {
    await into(cashSettings)
        .insert(const CashSetting(id: 1, withdrawalLimitMinor: 50000));
  }

  Future<void> _seedAdjustmentAccounts() => customStatement('''
    INSERT INTO ledger_accounts (name, currency, kind)
    SELECT 'cashAdjustment', c.code, 'cashAdjustment' FROM currencies c
    WHERE NOT EXISTS (
      SELECT 1 FROM ledger_accounts a WHERE a.currency = c.code AND a.kind = 'cashAdjustment'
    )
  ''');

  Future<void> _setupRemittances() async {
    await customStatement(
      'CREATE INDEX remittance_events_by_transfer ON remittance_events (remittance_id)',
    );
    for (final kind in [
      AccountKind.remittanceTransit,
      AccountKind.remittanceExchange,
    ]) {
      await customStatement(
        'INSERT INTO ledger_accounts (name, currency, kind) SELECT ?, code, ? FROM currencies',
        [kind.name, kind.name],
      );
    }
  }

  Future<void> _salaryIndexes() async {
    await customStatement(
      'CREATE INDEX salary_allocations_by_plan ON salary_allocations (salary_id)',
    );
    await customStatement(
      'CREATE INDEX salary_executions_by_movement ON salary_executions (entry_id)',
    );
  }
}
