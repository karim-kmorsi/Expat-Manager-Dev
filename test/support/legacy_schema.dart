import 'package:sqlite3/sqlite3.dart' as sqlite;

// Migration tests materialize an older schema from a fresh synthetic database.
void dropLeaveSchema(sqlite.Database database) {
  dropEntitlementSchema(database);
  for (final table in ['leave_entries', 'leave_holidays', 'leave_rules']) {
    database.execute('DROP TABLE $table');
  }
}

void dropEntitlementSchema(sqlite.Database database) {
  dropGoldSchema(database);
  for (final table in [
    'travel_contributions',
    'travel_goals',
    'annual_tickets',
    'dashain_plans',
  ]) {
    database.execute('DROP TABLE $table');
  }
}

void dropGoldSchema(sqlite.Database database) {
  dropSmartTransferSchema(database);
  for (final table in ['gold_events', 'gold_sales', 'gold_pieces']) {
    database.execute('DROP TABLE $table');
  }
}

const smartTransferTables = [
  'salary_allocation_details',
  'salary_exchange_rates',
  'remittance_exchange_rates',
];

void dropSmartTransferSchema(sqlite.Database database) {
  for (final table in smartTransferTables) {
    database.execute('DROP TABLE $table');
  }
}
