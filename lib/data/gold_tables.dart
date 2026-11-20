part of 'database.dart';

class GoldPieces extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get creationKey => text().unique()();
  TextColumn get label => text()();
  TextColumn get kind => textEnum<GoldKind>()();
  IntColumn get weightMg => integer()();
  IntColumn get karatHundredths => integer()();
  IntColumn get purchaseDay => integer().nullable()();
  IntColumn get purchaseMinor => integer().nullable()();
  TextColumn get purchaseCurrency =>
      text().nullable().references(Currencies, #code)();
  TextColumn get owner => text()();
  TextColumn get custodian => text()();
  TextColumn get notes => text().nullable()();

  @override
  List<String> get customConstraints => [
    'CHECK (weight_mg > 0)',
    'CHECK (karat_hundredths BETWEEN 1 AND 2400)',
    'CHECK ((purchase_minor IS NULL) = (purchase_currency IS NULL))',
  ];
}

class GoldSales extends Table {
  IntColumn get pieceId => integer().references(GoldPieces, #id)();
  IntColumn get saleDay => integer()();
  IntColumn get priceMinor => integer().nullable()();
  TextColumn get priceCurrency =>
      text().nullable().references(Currencies, #code)();
  IntColumn get receiptId =>
      integer().nullable().unique().references(JournalEntries, #id)();
  IntColumn get receiptRevision => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {pieceId};

  @override
  List<String> get customConstraints => [
    'CHECK ((price_minor IS NULL) = (price_currency IS NULL))',
  ];
}

@TableIndex(name: 'gold_events_by_piece', columns: {#pieceId, #id})
class GoldEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get pieceId => integer().references(GoldPieces, #id)();
  IntColumn get recordedMicros => integer()();
  TextColumn get kind => textEnum<GoldEventKind>()();
  TextColumn get changes => text()();
  IntColumn get journalId =>
      integer().nullable().references(JournalEntries, #id)();
}
