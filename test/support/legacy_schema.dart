import 'package:sqlite3/sqlite3.dart' as sqlite;

// Migration tests materialize an older schema from a fresh synthetic database.
void dropLeaveSchema(sqlite.Database database) {
  for (final table in ['leave_entries', 'leave_holidays', 'leave_rules']) {
    database.execute('DROP TABLE $table');
  }
}
