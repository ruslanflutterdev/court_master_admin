import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_event.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_state.dart';
import 'package:court_master_admin/features/employees/presentation/widgets/sheets/create_employee_sheet.dart';

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
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<EmployeesBloc>.value(value: mockEmployeesBloc),
            BlocProvider<AuthBloc>.value(value: mockAuthBloc),
          ],
          child: const CreateEmployeeSheet(),
        ),
      ),
    );
  }

  group('CreateEmployeeSheet Widget Tests', () {
    testWidgets('Отображает поля ввода и кнопку', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester
          .pumpAndSettle(); // Добавили pumpAndSettle для полного рендера формы

      // Ищем по типам виджетов или более надежным текстам
      expect(
        find.byType(TextFormField),
        findsWidgets,
      ); // Должно быть несколько текстовых полей
      expect(
        find.text('Создать сотрудника'),
        findsOneWidget,
      ); // Кнопка должна быть
    });
  });
}
