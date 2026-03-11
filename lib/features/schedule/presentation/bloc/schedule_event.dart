abstract class ScheduleEvent {}

class LoadScheduleData extends ScheduleEvent {
  final DateTime date;
  LoadScheduleData(this.date);
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
