part of 'database.dart';

class ExpenseDetails extends Table {
  IntColumn get entryId => integer().references(JournalEntries, #id)();
  TextColumn get period => textEnum<ExpensePeriod>()();
  IntColumn get startDay => integer()();
  TextColumn get category => textEnum<ExpenseCategory>().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {entryId};
}
