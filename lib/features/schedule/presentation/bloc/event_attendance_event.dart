abstract class EventAttendanceEvent {}

class LoadAttendanceEvent extends EventAttendanceEvent {
  final String eventId;
  LoadAttendanceEvent(this.eventId);
}

class MarkStudentEvent extends EventAttendanceEvent {
  final String eventId;
  final String studentId;
  final int status;
  MarkStudentEvent(this.eventId, this.studentId, this.status);
}
