import '../bloc/schedule/schedule_state.dart';

class ScheduleDateHelper {
  static Map<String, DateTime> getDateRange(
    DateTime currentDate,
    ScheduleViewType viewType,
  ) {
    DateTime startDate;
    DateTime endDate;

    switch (viewType) {
      case ScheduleViewType.day:
        startDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );
        endDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          23,
          59,
          59,
        );
        break;
      case ScheduleViewType.week:
        int daysToSubtract = currentDate.weekday - 1;
        startDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day - daysToSubtract,
        );
        endDate = startDate.add(
          const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        break;
      case ScheduleViewType.month:
        startDate = DateTime(currentDate.year, currentDate.month, 1);
        endDate = DateTime(
          currentDate.year,
          currentDate.month + 1,
          0,
          23,
          59,
          59,
        );
        break;
    }

    return {'start': startDate, 'end': endDate};
  }
}
