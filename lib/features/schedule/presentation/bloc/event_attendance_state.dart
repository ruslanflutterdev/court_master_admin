import '../../data/models/attendance_student_model.dart';

abstract class EventAttendanceState {}

class EventAttendanceLoading extends EventAttendanceState {}

class EventAttendanceError extends EventAttendanceState {
  final String message;
  EventAttendanceError(this.message);
}

class EventAttendanceLoaded extends EventAttendanceState {
  final List<AttendanceStudentModel> students;
  final String? errorMessage;

  EventAttendanceLoaded(this.students, {this.errorMessage});
}
