import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist_state.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/add_waitlist_sheet.dart';

class MockWaitlistBloc extends MockBloc<WaitlistEvent, WaitlistState>
    implements WaitlistBloc {}

class FakeWaitlistEvent extends Fake implements WaitlistEvent {}

void main() {
  group('AddWaitlistSheet Widget Tests', () {
    late MockWaitlistBloc mockBloc;
    final testDate = DateTime(2026, 3, 14);

    setUpAll(() {
      registerFallbackValue(FakeWaitlistEvent());
    });

    setUp(() {
      mockBloc = MockWaitlistBloc();
      // Для формы состояние не особо важно, но нужно задать дефолтное
      when(() => mockBloc.state).thenReturn(WaitlistInitial());
    });

    Widget buildWidget() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<WaitlistBloc>.value(
            value: mockBloc,
            child: AddWaitlistSheet(date: testDate),
          ),
        ),
      );
    }

    testWidgets('Отображает все необходимые поля ввода', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Записать в резерв'), findsOneWidget);
      expect(
        find.byType(TextField),
        findsNWidgets(2),
      ); // Поля "Имя" и "Телефон"
      expect(find.text('Добавить'), findsOneWidget);
    });

    testWidgets('При нажатии "Добавить" отправляется событие AddToWaitlist', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      // Находим поля
      final textFields = find.byType(TextField);

      // Вводим текст
      await tester.enterText(textFields.first, 'Анна Смирнова');
      await tester.enterText(textFields.last, '+77001234567');

      // Нажимаем кнопку добавления
      await tester.tap(find.text('Добавить'));

      // Ждем завершения анимации закрытия шторки (Navigator.pop)
      await tester.pumpAndSettle();

      // Проверяем, что событие улетело в BLoC
      verify(() => mockBloc.add(any(that: isA<AddToWaitlist>()))).called(1);
    });
  });
}
