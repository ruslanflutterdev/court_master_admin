import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/attendance_student_model.dart';
import '../../data/repositories/schedule_repository.dart';

// --- События ---
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

// --- Состояния ---
abstract class EventAttendanceState {}

class EventAttendanceLoading extends EventAttendanceState {}

class EventAttendanceError extends EventAttendanceState {
  final String message;
  EventAttendanceError(this.message);
}

class EventAttendanceLoaded extends EventAttendanceState {
  final List<AttendanceStudentModel> students;
  EventAttendanceLoaded(this.students);
}

// --- BLoC ---
class EventAttendanceBloc
    extends Bloc<EventAttendanceEvent, EventAttendanceState> {
  final ScheduleRepository repository;

  EventAttendanceBloc({required this.repository})
    : super(EventAttendanceLoading()) {
    on<LoadAttendanceEvent>((event, emit) async {
      emit(EventAttendanceLoading());
      try {
        final students = await repository.getEventAttendance(event.eventId);
        emit(EventAttendanceLoaded(students));
      } catch (e) {
        emit(EventAttendanceError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<MarkStudentEvent>((event, emit) async {
      try {
        // Отправляем отметку на сервер
        await repository.markAttendance(
          event.eventId,
          event.studentId,
          event.status,
        );
        // Сразу перезапрашиваем список, чтобы UI обновился
        add(LoadAttendanceEvent(event.eventId));
      } catch (e) {
        emit(EventAttendanceError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
