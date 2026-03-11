import '../../data/models/court_model.dart';
import '../../data/models/schedule_event_model.dart';
import '../../../groups/data/models/group_model.dart';
import '../../../employees/data/models/coach_model.dart';

abstract class ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}

class ScheduleLoaded extends ScheduleState {
  final DateTime scheduleDate;
  final List<CourtModel> courts;
  final List<ScheduleEventModel> scheduleEvents;
  final List<GroupModel> groups;
  final List<CoachModel> coaches;

  ScheduleLoaded({
    required this.scheduleDate,
    required this.courts,
    required this.scheduleEvents,
    required this.groups,
    required this.coaches,
  });
}
