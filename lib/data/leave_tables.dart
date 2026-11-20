part of 'database.dart';

class LeaveRules extends Table {
  IntColumn get effectiveDay => integer()();
  IntColumn get annualDays => integer()();
  IntColumn get casualDays => integer()();
  IntColumn get sickDays => integer()();

  @override
  Set<Column<Object>> get primaryKey => {effectiveDay};

  @override
  List<String> get customConstraints => [
    'CHECK (annual_days BETWEEN 0 AND 366)',
    'CHECK (casual_days BETWEEN 0 AND 366)',
    'CHECK (sick_days BETWEEN 0 AND 366)',
  ];
}

class LeaveEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<LeaveKind>()();
  TextColumn get status => textEnum<LeaveStatus>()();
  IntColumn get startDay => integer()();
  IntColumn get endDay => integer()();
  TextColumn get occasion => text().withLength(max: 120)();
  TextColumn get medicalReport => textEnum<MedicalReport>()();

  @override
  List<String> get customConstraints => ['CHECK (end_day >= start_day)'];
}

class LeaveHolidays extends Table {
  IntColumn get day => integer()();
  TextColumn get name => text().withLength(min: 1, max: 120)();

  @override
  Set<Column<Object>> get primaryKey => {day};
}
