import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sodium/sodium.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../finance/model.dart';
import 'schema_recovery.dart';

part 'database.g.dart';
part 'salary_tables.dart';

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
  ],
)
class LedgerDatabase extends _$LedgerDatabase {
  LedgerDatabase._(super.executor);

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
      if (raw.select('PRAGMA user_version').single.values.single == 1) {
        protectV1Migration(raw, file, hexKey);
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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) => transaction(() async {
      if (from != 1 || to != 2) throw StateError('Unsupported ledger schema');
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
      await customStatement(
        "CREATE UNIQUE INDEX system_account_by_currency ON ledger_accounts (currency, kind) "
        "WHERE kind IN ('opening', 'income', 'expense')",
      );
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
      // Persist the version with the schema and seed rows on first open.
      await customStatement('PRAGMA user_version = $schemaVersion');
    }),
  );

  Future<void> _salaryIndexes() async {
    await customStatement(
      'CREATE INDEX salary_allocations_by_plan ON salary_allocations (salary_id)',
    );
    await customStatement(
      'CREATE INDEX salary_executions_by_movement ON salary_executions (entry_id)',
    );
  }
}
