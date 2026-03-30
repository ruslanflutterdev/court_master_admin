import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist/waitlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist/waitlist_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist/waitlist_state.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/add_waitlist_sheet.dart';

class MockWaitlistBloc extends MockBloc<WaitlistEvent, WaitlistState>
    implements WaitlistBloc {}

// ❌ УБРАЛИ FakeWaitlistEvent, так как WaitlistEvent теперь sealed class

void main() {
  group('AddWaitlistSheet Widget Tests', () {
    late MockWaitlistBloc mockBloc;
    final testDate = DateTime(2026, 3, 14);

    setUpAll(() {
      // ✅ Используем РЕАЛЬНОЕ событие для FallbackValue
      registerFallbackValue(LoadWaitlist(testDate));
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

    testWidgets('Отображает поля для Аренды по умолчанию', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.text('Записать в резерв'), findsOneWidget);
      // По умолчанию выбрана 'Аренда', поэтому только 2 TextField: Имя и Телефон
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Добавить'), findsOneWidget);
    });

    testWidgets('Отображает дополнительные поля при переключении на "В группу"', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      // Переключаемся на сегмент "В группу"
      await tester.tap(find.text('В группу'));
      await tester.pumpAndSettle(); // Ждем завершения анимации

      // Проверяем, что появились новые текстовые поля (Имя, Телефон + Фамилия, Уровень, Комментарий = 5)
      expect(find.byType(TextField), findsNWidgets(5));

      // Убеждаемся, что специфичные тексты отрендерились
      expect(find.text('Фамилия'), findsOneWidget);
      expect(find.text('Уровень игры'), findsOneWidget);
    });

    testWidgets('При нажатии "Добавить" отправляется событие AddToWaitlist', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget());

      // Находим поля (по умолчанию мы в Аренде, их 2)
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
