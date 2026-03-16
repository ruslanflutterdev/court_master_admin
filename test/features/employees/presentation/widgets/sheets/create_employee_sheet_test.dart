import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_event.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_state.dart';
import 'package:court_master_admin/features/employees/presentation/widgets/sheets/create_employee_sheet.dart';

class MockEmployeesBloc extends MockBloc<EmployeesEvent, EmployeesState>
    implements EmployeesBloc {}

// Создаем фейковый ивент для Mocktail
class FakeEmployeesEvent extends Fake implements EmployeesEvent {}

void main() {
  late MockEmployeesBloc mockEmployeesBloc;

  setUpAll(() {
    registerFallbackValue(FakeEmployeesEvent());
  });

  setUp(() {
    mockEmployeesBloc = MockEmployeesBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<EmployeesBloc>.value(
          value: mockEmployeesBloc,
          child: const CreateEmployeeSheet(),
        ),
      ),
    );
  }

  group('CreateEmployeeSheet Widget Tests', () {
    testWidgets('Отображает все поля ввода', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Имя'), findsOneWidget);
      expect(find.text('Фамилия'), findsOneWidget);
      expect(find.text('Телефон'), findsOneWidget);
      expect(find.text('Email (логин)'), findsOneWidget);
      expect(find.text('Создать сотрудника'), findsOneWidget);
    });

    testWidgets('Показывает ошибки валидации при отправке пустой формы', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Нажимаем кнопку создания без ввода данных
      await tester.tap(find.text('Создать сотрудника'));
      await tester.pump(); // Ждем обновления UI для показа ошибок

      expect(find.text('Введите имя'), findsOneWidget);
      expect(find.text('Введите фамилию'), findsOneWidget);
      expect(find.text('Некорректный email'), findsOneWidget);

      // Проверяем, что событие в Bloc НЕ было отправлено
      verifyNever(() => mockEmployeesBloc.add(any()));
    });

    testWidgets('Отправляет событие AddCoachRequested при корректных данных', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Вводим данные
      await tester.enterText(find.widgetWithText(TextFormField, 'Имя'), 'Анна');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Фамилия'),
        'Смирнова',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email (логин)'),
        'anna@test.com',
      );

      // Закрываем клавиатуру
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Нажимаем кнопку создания
      await tester.tap(find.text('Создать сотрудника'));
      await tester.pump();

      // Проверяем, что Bloc получил событие добавления
      verify(
        () => mockEmployeesBloc.add(any(that: isA<AddCoachRequested>())),
      ).called(1);
    });
  });
}
