import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';
import 'package:court_master_admin/features/auth/presentation/screens/login_screen.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class FakeAuthEvent extends Fake implements AuthEvent {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
    registerFallbackValue(FakeAuthState());
  });

  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    when(() => mockAuthBloc.state).thenReturn(AuthInitial());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('1. Отрисовка всех элементов экрана', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(TextField), findsNWidgets(2)); // Email и Пароль
      expect(find.byType(ElevatedButton), findsOneWidget); // Кнопка входа
    });

    testWidgets('2. Нажатие на кнопку отправляет событие', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestableWidget());

      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;
      final loginButton = find.byType(ElevatedButton);

      await tester.enterText(emailField, 'test@admin.com');
      await tester.enterText(passwordField, 'password123');

      await tester.tap(loginButton);
      await tester.pumpAndSettle(); // Ждем завершения анимации кнопки

      verify(
        () => mockAuthBloc.add(any(that: isA<LoginRequested>())),
      ).called(1);
    });
  });
}
