part of 'database.dart';

class CashSettings extends Table {
  IntColumn get id => integer()();
  IntColumn get cashAccountId =>
      integer().nullable().references(LedgerAccounts, #id)();
  IntColumn get withdrawalLimitMinor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    "CHECK (id = 1 AND typeof(withdrawal_limit_minor) = 'integer' AND withdrawal_limit_minor >= 0)",
  ];
}

class CashReconciliations extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get accountId => integer().references(LedgerAccounts, #id)();
  IntColumn get priorMinor => integer()();
  IntColumn get countedMinor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {entryId};
}
