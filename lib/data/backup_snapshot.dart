import 'dart:convert';

import 'package:drift/drift.dart';

import '../finance/model.dart';
import '../finance/transfer_quote.dart';
import 'backup_envelope.dart';
import 'database.dart';

const _introduced = {
  'currencies': 1,
  'ledger_accounts': 1,
  'journal_entries': 1,
  'journal_postings': 1,
  'salary_receipts': 2,
  'salary_plans': 2,
  'salary_allocations': 2,
  'salary_executions': 2,
  'movement_confirmations': 2,
  'cash_settings': 3,
  'cash_reconciliations': 3,
  'expense_details': 4,
  'remittances': 5,
  'remittance_events': 5,
  'remittance_purposes': 5,
  'remittance_family_payments': 5,
  'leave_rules': 6,
  'leave_entries': 6,
  'leave_holidays': 6,
  'dashain_plans': 7,
  'annual_tickets': 7,
  'travel_goals': 7,
  'travel_contributions': 7,
  'gold_pieces': 8,
  'gold_sales': 8,
  'gold_events': 8,
  'salary_allocation_details': 9,
  'salary_exchange_rates': 9,
  'remittance_exchange_rates': 9,
};

typedef BackupRows = List<List<Object?>>;

class BackupSnapshot {
  BackupSnapshot._(this.schema, this.tables, this.sequences);

  final int schema;
  final Map<String, BackupRows> tables;
  final Map<String, int> sequences;

  int get accounts => tables['ledger_accounts']!
      .where((row) => AccountKind.values.byName(row[3]! as String).isPersonal)
      .length;
  int get movements => tables['journal_entries']!.length;
  int get leaveEntries => tables['leave_entries']?.length ?? 0;
  int get goldPieces => tables['gold_pieces']?.length ?? 0;

  Uint8List encode() => utf8.encode(
    jsonEncode({'schema': schema, 'tables': tables, 'sequences': sequences}),
  );

  static BackupSnapshot decode(Uint8List data, LedgerDatabase schemaSource) {
    final value = jsonDecode(utf8.decode(data));
    if (value is! Map<String, dynamic> ||
        value.length != 3 ||
        value['schema'] is! int ||
        value['tables'] is! Map<String, dynamic> ||
        value['sequences'] is! Map<String, dynamic>) {
      throw const BackupException(BackupIssue.invalidData);
    }
    final schema = value['schema'] as int;
    if (schema < 1 || schema > schemaSource.schemaVersion) {
      throw const BackupException(BackupIssue.unsupported);
    }
    final rows = value['tables'] as Map<String, dynamic>;
    final tables = _tables(schemaSource, schema);
    if (tables.length != rows.length) {
      throw const BackupException(BackupIssue.invalidData);
    }
    final parsed = <String, BackupRows>{};
    for (final table in tables) {
      final list = rows[table.actualTableName];
      if (list is! List) throw const BackupException(BackupIssue.invalidData);
      parsed[table.actualTableName] = [
        for (final row in list) _validateRow(table, row),
      ];
    }
    final sequences = <String, int>{};
    final counters = value['sequences'] as Map<String, dynamic>;
    for (final table in tables.where(_hasSequence)) {
      final name = table.actualTableName;
      final counter = counters[name];
      final idIndex = table.$columns.indexWhere(
        (column) => column.$name == 'id',
      );
      if (counter == null && parsed[name]!.isEmpty) continue;
      if (counter is! int ||
          counter < 0 ||
          parsed[name]!.any((row) => (row[idIndex]! as int) > counter)) {
        throw const BackupException(BackupIssue.invalidData);
      }
      sequences[name] = counter;
    }
    if (sequences.length != counters.length) {
      throw const BackupException(BackupIssue.invalidData);
    }
    return BackupSnapshot._(schema, parsed, sequences);
  }

  static Future<BackupSnapshot> read(LedgerDatabase db) async {
    final tables = <String, BackupRows>{};
    final sequences = <String, int>{};
    for (final table in _tables(db, db.schemaVersion)) {
      final name = table.actualTableName;
      final columns = _columns(table);
      final rows = await db
          .customSelect(
            'SELECT ${columns.join(', ')} FROM $name ORDER BY ${columns.join(', ')}',
          )
          .get();
      tables[name] = [
        for (final row in rows)
          [for (final column in columns) row.data[column]],
      ];
    }
    for (final row
        in await db
            .customSelect('SELECT name, seq FROM sqlite_sequence ORDER BY name')
            .get()) {
      final name = row.read<String>('name');
      if (tables.containsKey(name)) sequences[name] = row.read<int>('seq');
    }
    return BackupSnapshot._(db.schemaVersion, tables, sequences);
  }

  // The caller owns the transaction. Only schema-defined identifiers are written.
  Future<void> replace(LedgerDatabase db, {bool prepareLegacy = false}) async {
    await db.customStatement('PRAGMA defer_foreign_keys = ON');
    final all = _tables(db, db.schemaVersion);
    for (final table in all.reversed) {
      final name = table.actualTableName;
      await db.customStatement('DELETE FROM $name');
      if (prepareLegacy && _introduced[name]! > schema) {
        await db.customStatement('DROP TABLE $name');
      }
    }
    for (final table in _tables(db, schema)) {
      final columns = _columns(table);
      final marks = List.filled(columns.length, '?').join(', ');
      await db.batch((batch) {
        for (final row in tables[table.actualTableName]!) {
          batch.customStatement(
            'INSERT INTO ${table.actualTableName} (${columns.join(', ')}) VALUES ($marks)',
            row,
          );
        }
      });
    }
    await db.customStatement('DELETE FROM sqlite_sequence');
    for (final entry in sequences.entries) {
      await db.customStatement(
        'INSERT INTO sqlite_sequence(name,seq) VALUES (?, ?)',
        [entry.key, entry.value],
      );
    }
    if (prepareLegacy) {
      await db.customStatement('PRAGMA user_version = $schema');
    }
  }

  bool matches(BackupSnapshot other) {
    if (schema != other.schema ||
        tables.length != other.tables.length ||
        sequences.length != other.sequences.length ||
        sequences.entries.any(
          (entry) => other.sequences[entry.key] != entry.value,
        )) {
      return false;
    }
    for (final entry in tables.entries) {
      final rows = other.tables[entry.key];
      if (rows == null || rows.length != entry.value.length) return false;
      for (var i = 0; i < rows.length; i++) {
        final row = entry.value[i];
        if (row.length != rows[i].length) return false;
        for (var j = 0; j < row.length; j++) {
          if (row[j] != rows[i][j]) return false;
        }
      }
    }
    return true;
  }
}

List<TableInfo<Table, Object?>> _tables(LedgerDatabase db, int schema) {
  final all = db.allTables.toList();
  if (all.length != _introduced.length) {
    throw const BackupException(BackupIssue.unsupported);
  }
  return [
    for (final table in all)
      if (_introduced[table.actualTableName]! <= schema) table,
  ];
}

List<String> _columns(TableInfo<Table, Object?> table) => [
  for (final column in table.$columns) column.$name,
];

bool _hasSequence(TableInfo<Table, Object?> table) =>
    table.$columns.any((column) => column.hasAutoIncrement);

List<Object?> _validateRow(TableInfo<Table, Object?> table, Object? row) {
  if (row is! List || row.length != table.$columns.length) {
    throw const BackupException(BackupIssue.invalidData);
  }
  for (var index = 0; index < row.length; index++) {
    final column = table.$columns[index];
    final value = row[index];
    final valid = switch (column.type) {
      _ when value == null => column.$nullable,
      DriftSqlType.int => value is int,
      DriftSqlType.bool => value == 0 || value == 1,
      DriftSqlType.string => value is String,
      _ => false,
    };
    if (!valid) throw const BackupException(BackupIssue.invalidData);
  }
  // Drift maps saved enum names through the same converters used by the app.
  table.map({
    for (var i = 0; i < row.length; i++) table.$columns[i].$name: row[i],
  });
  return List<Object?>.of(row);
}

Future<void> validateRestoredLedger(LedgerDatabase db) async {
  final integrity = await db.customSelect('PRAGMA integrity_check').get();
  if (integrity.length != 1 ||
      integrity.single.data.values.single != 'ok' ||
      (await db.customSelect('PRAGMA foreign_key_check').get()).isNotEmpty) {
    throw const BackupException(BackupIssue.invalidData);
  }
  final currencies = {
    for (final c in await db.select(db.currencies).get()) c.code: c.scale,
  };
  final accounts = {
    for (final a in await db.select(db.ledgerAccounts).get()) a.id: a,
  };
  final systemAccounts = <String, Set<AccountKind>>{};
  for (final account in accounts.values.where((row) => !row.kind.isPersonal)) {
    (systemAccounts[account.currency] ??= {}).add(account.kind);
  }
  final requiredKinds = AccountKind.values.where((kind) => !kind.isPersonal);
  if (['USD', 'EGP', 'NPR'].any((code) => !currencies.containsKey(code)) ||
      currencies.keys.any(
        (code) => !(systemAccounts[code]?.containsAll(requiredKinds) ?? false),
      ) ||
      (await db.select(db.cashSettings).get()).length != 1 ||
      (await db.select(db.leaveRules).get()).isEmpty) {
    throw const BackupException(BackupIssue.invalidData);
  }

  final balances = <int, BigInt>{};
  final net = <int, Map<String, BigInt>>{};
  final postingCounts = <int, int>{};
  for (final posting in await db.select(db.journalPostings).get()) {
    final account = accounts[posting.accountId]!;
    final amount = BigInt.from(posting.minor);
    final byCurrency = net[posting.entryId] ??= {};
    byCurrency.update(
      account.currency,
      (sum) => sum + amount,
      ifAbsent: () => amount,
    );
    postingCounts.update(
      posting.entryId,
      (count) => count + 1,
      ifAbsent: () => 1,
    );
    if (account.kind.isPersonal) {
      balances.update(
        account.id,
        (sum) => sum + amount,
        ifAbsent: () => amount,
      );
    }
  }
  for (final entry in await db.select(db.journalEntries).get()) {
    final count = postingCounts[entry.id] ?? 0;
    if (count == 0 &&
        (entry.kind == JournalKind.opening ||
            entry.kind == JournalKind.cashAdjustment)) {
      continue;
    }
    if (count < 2 ||
        net[entry.id]!.values.any((amount) => amount != BigInt.zero)) {
      throw const BackupException(BackupIssue.invalidData);
    }
  }
  for (final balance in balances.values) {
    checkedMinor(balance);
  }
  for (final row in await db.select(db.salaryExchangeRates).get()) {
    if (row.currency == usdCurrency ||
        !transferCurrencies.contains(row.currency) ||
        exchangeRateUnits(row.rate) == null) {
      throw const BackupException(BackupIssue.invalidData);
    }
  }
  for (final row in await db.select(db.remittanceExchangeRates).get()) {
    if (exchangeRateUnits(row.rate) == null) {
      throw const BackupException(BackupIssue.invalidData);
    }
  }
  for (final row in await db.customSelect('''
      SELECT d.transfer_json, a.planned_minor
      FROM salary_allocation_details d JOIN salary_allocations a ON a.id=d.allocation_id
      WHERE d.transfer_json IS NOT NULL
    ''').get()) {
    final plan = TransferPlan.fromJson(
      jsonDecode(row.read<String>('transfer_json')) as Map<String, dynamic>,
    );
    if (plan.calculate(currencies).debit != row.read<int>('planned_minor')) {
      throw const BackupException(BackupIssue.invalidData);
    }
  }
  if ((await db.customSelect(
        '''
      SELECT a.salary_id FROM salary_allocations a
      JOIN salary_receipts r ON r.entry_id = a.salary_id
      JOIN journal_postings p ON p.entry_id = r.entry_id AND p.account_id = r.account_id
      GROUP BY a.salary_id HAVING SUM(a.planned_minor) > p.minor
    ''',
      ).get()).isNotEmpty ||
      (await db.customSelect('''
      SELECT x.allocation_id FROM salary_executions x
      JOIN salary_allocations a ON a.id = x.allocation_id
      WHERE NOT EXISTS (SELECT 1 FROM journal_entries j WHERE j.reversal_of = x.entry_id)
      GROUP BY x.allocation_id HAVING SUM(x.minor) > a.planned_minor
    ''').get()).isNotEmpty) {
    throw const BackupException(BackupIssue.invalidData);
  }
}
