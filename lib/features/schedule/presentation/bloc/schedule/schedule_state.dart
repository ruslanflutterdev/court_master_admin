import '../../../data/models/court_model.dart';
import '../../../data/models/schedule_event_model.dart';
import '../../../../groups/data/models/group_model.dart';
import '../../../../employees/data/models/coach_model.dart';

enum ScheduleViewType { day, week, month }

sealed class ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}

class ScheduleLoaded extends ScheduleState {
  final DateTime scheduleDate;
  final ScheduleViewType viewType;
  final List<CourtModel> courts;
  final List<ScheduleEventModel> scheduleEvents;
  final List<GroupModel> groups;
  final List<CoachModel> coaches;

  ScheduleLoaded({
    required this.scheduleDate,
    this.viewType = ScheduleViewType.day,
    required this.courts,
    required this.scheduleEvents,
    required this.groups,
    required this.coaches,
  });

  ScheduleLoaded copyWith({
    DateTime? scheduleDate,
    ScheduleViewType? viewType,
    List<CourtModel>? courts,
    List<ScheduleEventModel>? scheduleEvents,
    List<GroupModel>? groups,
    List<CoachModel>? coaches,
  }) {
    return ScheduleLoaded(
      scheduleDate: scheduleDate ?? this.scheduleDate,
      viewType: viewType ?? this.viewType,
      courts: courts ?? this.courts,
      scheduleEvents: scheduleEvents ?? this.scheduleEvents,
      groups: groups ?? this.groups,
      coaches: coaches ?? this.coaches,
    );
  }
}
