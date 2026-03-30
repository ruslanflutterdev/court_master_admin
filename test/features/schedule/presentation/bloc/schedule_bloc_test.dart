import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/schedule/data/repositories/schedule_repository.dart';
import 'package:court_master_admin/features/groups/data/repositories/groups_repository.dart';
import 'package:court_master_admin/features/employees/data/repositories/employees_repository.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule/schedule_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule/schedule_state.dart';

// Создаем сразу 3 "фейковых" репозитория
class MockScheduleRepo extends Mock implements ScheduleRepository {}

class MockGroupsRepo extends Mock implements GroupsRepository {}

class MockEmployeesRepo extends Mock implements EmployeesRepository {}

void main() {
  group('ScheduleBloc Tests', () {
    late ScheduleBloc bloc;
    late MockScheduleRepo mockScheduleRepo;
    late MockGroupsRepo mockGroupsRepo;
    late MockEmployeesRepo mockEmployeesRepo;

    setUp(() {
      mockScheduleRepo = MockScheduleRepo();
      mockGroupsRepo = MockGroupsRepo();
      mockEmployeesRepo = MockEmployeesRepo();
      bloc = ScheduleBloc(
        scheduleRepo: mockScheduleRepo,
        groupsRepo: mockGroupsRepo,
        employeesRepo: mockEmployeesRepo,
      );
    });

    tearDown(() {
      bloc.close();
    });

    test('Начальное состояние — ScheduleLoading', () {
      expect(bloc.state, isA<ScheduleLoading>());
    });

    blocTest<ScheduleBloc, ScheduleState>(
      'Успешная загрузка расписания: [ScheduleLoading, ScheduleLoaded]',
      build: () {
        // Учим фейки отдавать пустые списки, чтобы избежать ошибок null
        when(() => mockScheduleRepo.getCourts()).thenAnswer((_) async => []);

        // ИСПРАВЛЕНО: Указываем, что getEvents принимает параметры дат!
        when(
          () => mockScheduleRepo.getEvents(
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => []);

        when(() => mockGroupsRepo.getGroups()).thenAnswer((_) async => []);
        when(() => mockEmployeesRepo.getCoaches()).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadScheduleData(DateTime(2026, 3, 12))),
      expect: () => [isA<ScheduleLoading>(), isA<ScheduleLoaded>()],
    );

    blocTest<ScheduleBloc, ScheduleState>(
      'Ошибка сети при загрузке кортов: [ScheduleLoading, ScheduleError]',
      build: () {
        // Имитируем падение сервера при запросе кортов
        when(
          () => mockScheduleRepo.getCourts(),
        ).thenThrow(Exception('Ошибка сети'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadScheduleData(DateTime(2026, 3, 12))),
      expect: () => [isA<ScheduleLoading>(), isA<ScheduleError>()],
    );
  });
}
