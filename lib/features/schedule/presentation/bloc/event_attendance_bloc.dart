import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/schedule_repository.dart';
import 'event_attendance_event.dart';
import 'event_attendance_state.dart';

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
        await repository.markAttendance(
          event.eventId,
          event.studentId,
          event.status,
        );
        add(LoadAttendanceEvent(event.eventId));
      } catch (e) {
        emit(EventAttendanceError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
