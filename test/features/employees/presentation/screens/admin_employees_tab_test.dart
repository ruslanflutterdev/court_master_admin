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

// Добавляем импорты AuthBloc
import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';
import 'package:court_master_admin/features/auth/data/models/user_model.dart';

class MockEmployeesBloc extends MockBloc<EmployeesEvent, EmployeesState>
    implements EmployeesBloc {}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockEmployeesBloc mockEmployeesBloc;
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockEmployeesBloc = MockEmployeesBloc();
    mockAuthBloc = MockAuthBloc();

    // Задаем пользователя SUPER_ADMIN, чтобы кнопка создания тренера отображалась
    final dummyUser = UserModel(
      id: '1',
      email: 'admin@test.com',
      firstName: 'Admin',
      lastName: '',
      role: 'SUPER_ADMIN',
    );
    when(
      () => mockAuthBloc.state,
    ).thenReturn(AuthAuthenticated(user: dummyUser));
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<AuthBloc>.value(
      value: mockAuthBloc,
      child: MaterialApp(
        home: BlocProvider<EmployeesBloc>.value(
          value: mockEmployeesBloc,
          child: const AdminEmployeesTab(),
        ),
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

      final fab = find.byType(FloatingActionButton);
      expect(fab, findsOneWidget);

      await tester.tap(fab);
      await tester.pumpAndSettle();

      expect(find.text('Новый сотрудник'), findsOneWidget);
      expect(find.text('Создать сотрудника'), findsOneWidget);
    });
  });
}
