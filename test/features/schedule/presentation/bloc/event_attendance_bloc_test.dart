import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/schedule/data/repositories/schedule_repository.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/event_attendance_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/event_attendance_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/event_attendance_state.dart';

class MockScheduleRepo extends Mock implements ScheduleRepository {}

void main() {
  group('EventAttendanceBloc Tests', () {
    late EventAttendanceBloc bloc;
    late MockScheduleRepo mockRepo;

    setUp(() {
      mockRepo = MockScheduleRepo();
      bloc = EventAttendanceBloc(repository: mockRepo);
    });

    tearDown(() {
      bloc.close();
    });

    test('Начальное состояние — EventAttendanceLoading', () {
      expect(bloc.state, isA<EventAttendanceLoading>());
    });

    blocTest<EventAttendanceBloc, EventAttendanceState>(
      'Успешная загрузка списка учеников: [EventAttendanceLoading, EventAttendanceLoaded]',
      build: () {
        when(
          () => mockRepo.getEventAttendance('e1'),
        ).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAttendanceEvent('e1')),
      expect: () => [
        isA<EventAttendanceLoading>(),
        isA<EventAttendanceLoaded>(),
      ],
    );

    blocTest<EventAttendanceBloc, EventAttendanceState>(
      'Отметка студента вызывает перезагрузку списка',
      build: () {
        // Сначала отрабатывает отметка (возвращаем пустоту)
        when(
          () => mockRepo.markAttendance('e1', 's1', 1),
        ).thenAnswer((_) async {});
        // Затем BLoC сам вызывает перезагрузку списка
        when(
          () => mockRepo.getEventAttendance('e1'),
        ).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(MarkStudentEvent('e1', 's1', 1)),
      expect: () => [
        isA<
          EventAttendanceLoading
        >(), // Вызывается внутренним LoadAttendanceEvent
        isA<EventAttendanceLoaded>(),
      ],
    );
  });
}
