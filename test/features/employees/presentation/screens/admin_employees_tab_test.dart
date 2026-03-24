import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_event.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_state.dart';
import 'package:court_master_admin/features/employees/presentation/screens/admin_employees_tab.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';
import 'package:court_master_admin/features/employees/presentation/widgets/cards/employee_list_card.dart';

class MockEmployeesBloc extends MockBloc<EmployeesEvent, EmployeesState>
    implements EmployeesBloc {}

void main() {
  late MockEmployeesBloc mockEmployeesBloc;

  setUp(() {
    mockEmployeesBloc = MockEmployeesBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<EmployeesBloc>.value(
        value: mockEmployeesBloc,
        child: const AdminEmployeesTab(),
      ),
    );
  }

  group('AdminEmployeesTab Widget Tests', () {
    testWidgets(
      'Показывает индикатор загрузки, когда состояние EmployeesLoading',
      (tester) async {
        when(() => mockEmployeesBloc.state).thenReturn(EmployeesLoading());

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('Показывает сообщение о пустом списке, если тренеров нет', (
      tester,
    ) async {
      when(() => mockEmployeesBloc.state).thenReturn(EmployeesLoaded([]));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.textContaining('Нет добавленных тренеров'), findsOneWidget);
    });

    testWidgets(
      'Показывает список тренеров, если состояние EmployeesLoaded с данными',
      (tester) async {
        final coaches = [
          CoachModel(
            id: '1',
            firstName: 'Иван',
            lastName: 'Иванов',
            role: 'COACH',
            rating: 5.0,
            email: '',
          ),
        ];
        when(
          () => mockEmployeesBloc.state,
        ).thenReturn(EmployeesLoaded(coaches));

        await tester.pumpWidget(createWidgetUnderTest());

        expect(find.byType(EmployeeListCard), findsOneWidget);
        expect(find.text('Иван Иванов'), findsOneWidget);
      },
    );

    testWidgets('Нажатие на FAB открывает шторку создания тренера', (
      tester,
    ) async {
      when(() => mockEmployeesBloc.state).thenReturn(EmployeesLoaded([]));

      await tester.pumpWidget(createWidgetUnderTest());

      // Ищем кнопку FAB
      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      // Нажимаем на неё
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Проверяем, что шторка открылась (ищем текст заголовка шторки)
      expect(find.text('Новый сотрудник'), findsOneWidget);
      expect(find.text('Создать сотрудника'), findsOneWidget);
    });
  });
}
