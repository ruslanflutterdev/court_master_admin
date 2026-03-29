import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_state.dart';

abstract class ScheduleEvent {}

class LoadScheduleData extends ScheduleEvent {
  final DateTime date;
  final ScheduleViewType? viewType;
  LoadScheduleData(this.date, {this.viewType});
}

class CreateCourtRequested extends ScheduleEvent {
  final String name;
  CreateCourtRequested(this.name);
}

class UpdateCourtRequested extends ScheduleEvent {
  final String courtId;
  final String name;
  UpdateCourtRequested(this.courtId, this.name);
}

class CreateScheduleEventRequested extends ScheduleEvent {
  final Map<String, dynamic> eventData;
  CreateScheduleEventRequested(this.eventData);
}

class ChangeScheduleViewTypeRequested extends ScheduleEvent {
  final ScheduleViewType viewType;
  ChangeScheduleViewTypeRequested(this.viewType);
}

class UpdateScheduleEvent extends ScheduleEvent {
  final String eventId;
  final Map<String, dynamic> eventData;
  final DateTime currentDate;

  UpdateScheduleEvent({
    required this.eventId,
    required this.eventData,
    required this.currentDate,
  });
}

class CancelScheduleEventRequested extends ScheduleEvent {
  final String eventId;
  final DateTime currentDate;

  CancelScheduleEventRequested(this.eventId, this.currentDate);
}

class CancelScheduleEventSeriesRequested extends ScheduleEvent {
  final String seriesId;
  final DateTime currentDate;

  CancelScheduleEventSeriesRequested(this.seriesId, this.currentDate);
}
