part of 'database.dart';

class Remittances extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get draftKey => text().unique()();
  @ReferenceName('outgoingRemittances')
  IntColumn get sourceAccountId => integer().references(LedgerAccounts, #id)();
  @ReferenceName('incomingRemittances')
  IntColumn get destinationAccountId =>
      integer().nullable().references(LedgerAccounts, #id)();
  TextColumn get destinationCurrency => text().references(Currencies, #code)();
  TextColumn get destination => textEnum<RemittanceDestination>()();
  TextColumn get beneficiary => text().nullable()();
  BoolColumn get cancelled => boolean().withDefault(const Constant(false))();
  BoolColumn get awaiting => boolean().withDefault(const Constant(false))();

  @override
  List<String> get customConstraints => [
    """CHECK ((destination = 'personal' AND destination_account_id IS NOT NULL AND
      destination_account_id <> source_account_id AND beneficiary IS NULL) OR
      (destination IN ('family','beneficiary') AND destination_account_id IS NULL AND
      beneficiary IS NOT NULL))""",
  ];
}

class RemittanceEvents extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  IntColumn get remittanceId => integer().references(Remittances, #id)();
  TextColumn get kind => textEnum<RemittanceEventKind>()();
  TextColumn get evidence => text()();
  IntColumn get feeMinor => integer().nullable()();
  @ReferenceName('remittanceSourceProofs')
  IntColumn get receiptEntryId =>
      integer().nullable().references(JournalEntries, #id)();

  @override
  Set<Column<Object>> get primaryKey => {entryId};
}

class RemittancePurposes extends Table {
  TextColumn get operationKey => text()();
  IntColumn get remittanceId => integer().references(Remittances, #id)();
  TextColumn get label => text()();
  IntColumn get minor => integer()();
  BoolColumn get family => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {operationKey};

  @override
  List<String> get customConstraints => [
    "CHECK (typeof(minor) = 'integer' AND minor > 0)",
  ];
}

class RemittanceFamilyPayments extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  TextColumn get purposeKey =>
      text().references(RemittancePurposes, #operationKey)();

  @override
  Set<Column<Object>> get primaryKey => {entryId};
}

class RemittanceExchangeRates extends Table {
  IntColumn get entryId => integer().references(RemittanceEvents, #entryId)();
  TextColumn get rate => text()();

  @override
  Set<Column<Object>> get primaryKey => {entryId};
}
