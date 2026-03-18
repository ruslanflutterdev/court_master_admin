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
        when(
          () => mockRepo.markAttendance('e1', 's1', 1),
        ).thenAnswer((_) async {});
        when(
          () => mockRepo.getEventAttendance('e1'),
        ).thenAnswer((_) async => []);
        return bloc;
      },
      seed: () => EventAttendanceLoaded([]),
      act: (bloc) => bloc.add(MarkStudentEvent('e1', 's1', 1)),
      expect: () => [
        isA<EventAttendanceLoading>(),
        isA<EventAttendanceLoaded>(),
      ],
    );

    blocTest<EventAttendanceBloc, EventAttendanceState>(
      'Ошибка при отметке показывает сообщение, но сохраняет список',
      build: () {
        when(
          () => mockRepo.markAttendance('e1', 's1', 1),
        ).thenThrow(Exception('Нет активного абонемента'));
        return bloc;
      },
      seed: () => EventAttendanceLoaded([]),
      act: (bloc) => bloc.add(MarkStudentEvent('e1', 's1', 1)),
      expect: () => [
        isA<EventAttendanceLoaded>().having(
          (s) => s.errorMessage,
          'errorMessage',
          contains('Нет активного абонемента'),
        ),
      ],
    );
  });
}
