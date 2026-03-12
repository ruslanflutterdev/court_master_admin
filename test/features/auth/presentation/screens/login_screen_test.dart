import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:court_master_admin/features/auth/presentation/screens/login_screen.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';

// 1. Создаем подделку для BLoC
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

// 2. Фейковое событие нужно для работы mocktail
class FakeAuthEvent extends Fake implements AuthEvent {}

void main() {
  // Настройка mocktail перед всеми тестами
  setUpAll(() {
    registerFallbackValue(FakeAuthEvent());
  });

  group('LoginScreen Widget Tests', () {
    late MockAuthBloc mockAuthBloc;

    setUp(() {
      mockAuthBloc = MockAuthBloc();
    });

    // Функция для создания тестового экрана (оборачиваем экран в MaterialApp и BLoC)
    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>.value(
          value: mockAuthBloc,
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('1. Отрисовка всех элементов экрана', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      // Проверяем, что робот видит текст, 2 поля ввода и кнопку
      expect(find.text('CourtMaster CRM'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Войти'), findsOneWidget);
    });

    testWidgets('2. Показ крутилки при загрузке', (WidgetTester tester) async {
      // Имитируем, что BLoC сейчас находится в состоянии загрузки
      when(() => mockAuthBloc.state).thenReturn(AuthLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      // Проверяем, что появилась крутилка, а кнопка "Войти" исчезла
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Войти'), findsNothing);
    });

    testWidgets('3. Показ SnackBar при ошибке', (WidgetTester tester) async {
      // Имитируем "поток" состояний: сначала Initial, потом прилетает Error
      whenListen(
        mockAuthBloc,
        Stream.fromIterable([AuthError('Неверный пароль')]),
        initialState: AuthInitial(),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Ждем, пока анимация всплывающего SnackBar завершится

      // Проверяем, что робот увидел на экране текст ошибки
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Неверный пароль'), findsOneWidget);
    });

    testWidgets('4. Нажатие на кнопку отправляет событие', (WidgetTester tester) async {
      when(() => mockAuthBloc.state).thenReturn(AuthInitial());

      await tester.pumpWidget(createWidgetUnderTest());

      // Робот нажимает на кнопку "Войти"
      await tester.tap(find.text('Войти'));
      await tester.pump();

      // Проверяем, что в наш (фейковый) BLoC действительно "прилетело" событие LoginRequested
      verify(() => mockAuthBloc.add(any(that: isA<LoginRequested>()))).called(1);
    });
  });
}