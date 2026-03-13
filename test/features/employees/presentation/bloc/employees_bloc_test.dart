import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';
import 'package:court_master_admin/features/employees/data/repositories/employees_repository.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_event.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_state.dart';

// 1. Создаем Mock-класс (Подделку) для репозитория
class MockEmployeesRepository extends Mock implements EmployeesRepository {}

void main() {
  group('EmployeesBloc Tests', () {
    late EmployeesBloc employeesBloc;
    late MockEmployeesRepository mockRepository;

    // setUp выполняется перед КАЖДЫМ тестом (обнуляем состояние)
    setUp(() {
      mockRepository = MockEmployeesRepository();
      employeesBloc = EmployeesBloc(repository: mockRepository);
    });

    // tearDown выполняется после КАЖДОГО теста (закрываем поток)
    tearDown(() {
      employeesBloc.close();
    });

    // Тест 1: Проверяем, что при старте стейт = Loading
    test('Начальное состояние должно быть EmployeesLoading', () {
      expect(employeesBloc.state, isA<EmployeesLoading>());
    });

    // Тест 2: Успешная загрузка данных
    blocTest<EmployeesBloc, EmployeesState>(
      'Должен выдать [EmployeesLoading, EmployeesLoaded], когда данные успешно получены',
      build: () {
        // Учим наш фейковый репозиторий отдавать список из одного тренера
        when(() => mockRepository.getCoaches()).thenAnswer(
          (_) async => [
            CoachModel(id: '1', firstName: 'Иван', phone: '+79991234567'),
          ],
        );
        return employeesBloc;
      },
      act: (bloc) => bloc.add(LoadEmployeesEvent()),
      expect: () => [
        isA<EmployeesLoading>(),
        isA<EmployeesLoaded>(), // Проверяем, что стейт сменился на Loaded
      ],
    );

    // Тест 3: Сервер вернул ошибку
    blocTest<EmployeesBloc, EmployeesState>(
      'Должен выдать [EmployeesLoading, EmployeesError], если сервер упал',
      build: () {
        // Учим фейковый репозиторий выбрасывать исключение
        when(
          () => mockRepository.getCoaches(),
        ).thenThrow(Exception('Нет интернета'));
        return employeesBloc;
      },
      act: (bloc) => bloc.add(LoadEmployeesEvent()),
      expect: () => [
        isA<EmployeesLoading>(),
        isA<
          EmployeesError
        >(), // Проверяем, что BLoC поймал ошибку и выдал Error-стейт
      ],
    );
  });
}
