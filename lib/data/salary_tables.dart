part of 'database.dart';

class SalaryReceipts extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get accountId => integer().references(LedgerAccounts, #id)();
  TextColumn get reference => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {entryId};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {accountId, reference},
  ];
}

class SalaryPlans extends Table {
  IntColumn get salaryId => integer().references(SalaryReceipts, #entryId)();

  @override
  Set<Column<Object>> get primaryKey => {salaryId};
}

class SalaryAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get salaryId => integer().references(SalaryPlans, #salaryId)();
  TextColumn get label => text()();
  IntColumn get plannedMinor => integer()();

  @override
  List<String> get customConstraints => ['CHECK (planned_minor > 0)'];
}

class SalaryExecutions extends Table {
  IntColumn get allocationId => integer().references(SalaryAllocations, #id)();
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get minor => integer()();

  @override
  Set<Column<Object>> get primaryKey => {allocationId, entryId};

  @override
  List<String> get customConstraints => ['CHECK (minor > 0)'];
}

class MovementConfirmations extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  TextColumn get evidence => text()();
  IntColumn get confirmedMicros => integer()();

  @override
  Set<Column<Object>> get primaryKey => {entryId};
}

class SalaryAllocationDetails extends Table {
  IntColumn get allocationId => integer().references(
    SalaryAllocations,
    #id,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get category => textEnum<AllocationCategory>().nullable()();
  TextColumn get transferJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {allocationId};
}

class SalaryExchangeRates extends Table {
  TextColumn get currency => text().references(Currencies, #code)();
  TextColumn get rate => text()();

  @override
  Set<Column<Object>> get primaryKey => {currency};
}
