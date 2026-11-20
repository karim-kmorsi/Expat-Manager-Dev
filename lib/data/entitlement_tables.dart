part of 'database.dart';

class DashainPlans extends Table {
  IntColumn get year => integer()();
  IntColumn get festivalDay => integer()();
  TextColumn get currency => text().references(Currencies, #code)();
  IntColumn get salaryMinor => integer()();
  IntColumn get allowancesMinor => integer()();
  IntColumn get receiptId =>
      integer().nullable().unique().references(JournalEntries, #id)();
  IntColumn get revision => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {year};
}

class AnnualTickets extends Table {
  IntColumn get year => integer()();
  IntColumn get policyVersion => integer()();
  IntColumn get receivedDay => integer().nullable()();
  IntColumn get usedDay => integer().nullable()();
  IntColumn get leaveId => integer().nullable().references(LeaveEntries, #id)();

  @override
  Set<Column<Object>> get primaryKey => {year};
}

class TravelGoals extends Table {
  IntColumn get id => integer()();
  TextColumn get currency => text().references(Currencies, #code)();
  IntColumn get targetDay => integer()();
  IntColumn get tripMinor => integer()();
  IntColumn get airfareMinor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class TravelContributions extends Table {
  TextColumn get operationId => text()();
  IntColumn get goalId => integer().references(TravelGoals, #id)();
  IntColumn get accountId => integer().references(LedgerAccounts, #id)();
  IntColumn get day => integer()();
  IntColumn get minor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {operationId};
}
