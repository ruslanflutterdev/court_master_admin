import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/core/presentation/widgets/primary_button.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_state.dart';
import 'package:court_master_admin/features/employees/presentation/widgets/sheets/create_employee_sheet.dart';

class MockEmployeesBloc extends Mock implements EmployeesBloc {}

void main() {
  late MockEmployeesBloc mockBloc;

  setUp(() {
    mockBloc = MockEmployeesBloc();
    // 🚀 ИСПРАВЛЕНО: Заменили EmployeesInitial на EmployeesLoading
    when(() => mockBloc.state).thenReturn(EmployeesLoading());
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<EmployeesBloc>.value(
          value: mockBloc,
          child: const CreateEmployeeSheet(),
        ),
      ),
    );
  }

  group('CreateEmployeeSheet Widget Tests', () {
    testWidgets('Отображает поля ввода и кнопку', (tester) async {
      await tester.pumpWidget(buildWidget());

      // Ищем текстовые поля (Имя, Фамилия, Email, Телефон, Пароль)
      expect(find.byType(TextFormField), findsWidgets);
      // Ищем нашу новую универсальную кнопку из Core
      expect(find.byType(PrimaryButton), findsOneWidget);
    });
  });
}
