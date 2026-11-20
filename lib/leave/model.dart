enum LeaveKind { annual, casual, sick }

enum LeaveStatus {
  requested,
  approved,
  used,
  cancelled;

  bool get reservesDays => this == approved || this == used;
}

enum MedicalReport { unspecified, pending, recorded }

enum LeaveIssue {
  dates,
  balance,
  overlap,
  duplicate,
  used,
  missing,
  holiday,
  policy,
}

class LeaveException implements Exception {
  const LeaveException(this.issue);
  final LeaveIssue issue;
}

// These are civil dates, not timestamps. UTC keeps day arithmetic independent
// of the device time zone and daylight saving changes.
DateTime leaveDate(DateTime date) =>
    DateTime.utc(date.year, date.month, date.day);

const _epochMillisecondsPerDay = 86400000;
int leaveDay(DateTime date) =>
    leaveDate(date).millisecondsSinceEpoch ~/ _epochMillisecondsPerDay;
DateTime dateOfLeaveDay(int day) => DateTime.fromMillisecondsSinceEpoch(
  day * _epochMillisecondsPerDay,
  isUtc: true,
);

final firstLeaveDate = DateTime.utc(1900);
final lastLeaveDate = DateTime.utc(2100, 12, 31);

enum LeavePlanningMode { exact, window, occasion }

typedef LeaveBalance = ({
  int entitlement,
  int used,
  int reserved,
  int remaining,
});

class LeavePeriod {
  const LeavePeriod(this.startDay, this.endDay);

  final int startDay;
  final int endDay;

  int get days => endDay - startDay + 1;
  int get chargeYear => dateOfLeaveDay(startDay).year;

  bool overlaps(LeavePeriod other) =>
      startDay <= other.endDay && endDay >= other.startDay;
}

class LeaveCalendar {
  LeaveCalendar(Iterable<int> holidays) : holidays = Set.unmodifiable(holidays);

  final Set<int> holidays;

  bool isWorkDay(int day) {
    final weekday = dateOfLeaveDay(day).weekday;
    return weekday != DateTime.friday &&
        weekday != DateTime.saturday &&
        !holidays.contains(day);
  }

  int returnDay(LeavePeriod period) {
    var day = period.endDay + 1;
    while (!isWorkDay(day)) {
      day++;
    }
    return day;
  }

  LeavePeriod continuousBreak(LeavePeriod period) {
    var before = period.startDay - 1;
    while (!isWorkDay(before)) {
      before--;
    }
    return LeavePeriod(before + 1, returnDay(period) - 1);
  }
}
