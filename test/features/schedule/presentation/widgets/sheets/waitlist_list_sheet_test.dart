import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist/waitlist_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist/waitlist_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist/waitlist_state.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/waitlist_list_sheet.dart';
import 'package:court_master_admin/features/schedule/data/models/waitlist_model.dart';

// Создаем "фейковый" BLoC для подмены реального
class MockWaitlistBloc extends MockBloc<WaitlistEvent, WaitlistState>
    implements WaitlistBloc {}

// ❌ УБРАЛИ FakeWaitlistEvent, так как WaitlistEvent теперь sealed class

void main() {
  group('WaitlistListSheet Widget Tests', () {
    late MockWaitlistBloc mockBloc;
    final testDate = DateTime(2026, 3, 14);

    setUpAll(() {
      // ✅ ИСПОЛЬЗУЕМ РЕАЛЬНОЕ СОБЫТИЕ ДЛЯ FALLBACK
      registerFallbackValue(LoadWaitlist(testDate));
    });

    setUp(() {
      mockBloc = MockWaitlistBloc();
    });

    // Вспомогательная функция для оборачивания виджета
    Widget buildWidget() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<WaitlistBloc>.value(
            value: mockBloc,
            child: WaitlistListSheet(date: testDate),
          ),
        ),
      );
    }

    testWidgets(
      'Показывает CircularProgressIndicator при состоянии WaitlistLoading',
      (tester) async {
        when(() => mockBloc.state).thenReturn(WaitlistLoading());

        await tester.pumpWidget(buildWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('Показывает сообщение "Пока никого нет", если списки пусты', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(
        WaitlistLoaded(rentalWaitlist: [], groupWaitlist: [], date: testDate),
      );

      await tester.pumpWidget(buildWidget());

      // TabBarView по умолчанию отрисовывает активную вкладку
      expect(find.text('Пока никого нет'), findsOneWidget);
    });

    testWidgets(
      'Отображает список аренды и кнопку удаления (Вкладка "Аренда")',
      (tester) async {
        final mockRentalWaitlist = [
          WaitlistModel(
            id: 'w1',
            type: 'RENTAL', // Добавили тип
            date: testDate,
            startTime: '18:00',
            endTime: '19:00',
            clientName: 'Иван',
            lastName: 'Иванов', // Имя и фамилия теперь разделены
            clientPhone: '+79990001122',
            status: 'pending',
          ),
        ];

        when(() => mockBloc.state).thenReturn(
          WaitlistLoaded(
            rentalWaitlist: mockRentalWaitlist,
            groupWaitlist: [],
            date: testDate,
          ),
        );

        await tester.pumpWidget(buildWidget());

        // Проверяем, что данные отрисовались на первой вкладке
        expect(find.text('Иван Иванов'), findsOneWidget);
        expect(find.text('18:00 - 19:00 | +79990001122'), findsOneWidget);

        // Нажимаем на кнопку корзины (удаление)
        await tester.tap(find.byIcon(Icons.delete));
        await tester.pump();

        // Проверяем, что в BLoC улетело событие RemoveFromWaitlist
        verify(
          () => mockBloc.add(any(that: isA<RemoveFromWaitlist>())),
        ).called(1);
      },
    );

    testWidgets(
      'Отображает список групп при переключении на вкладку "В группу"',
      (tester) async {
        final mockGroupWaitlist = [
          WaitlistModel(
            id: 'g1',
            type: 'GROUP',
            clientName: 'Анна',
            lastName: 'Смирнова',
            clientPhone: '+79998887766',
            gameLevel: 'Продвинутый',
            ageGroup: '18+',
            comment: 'Хочет в вечернюю группу',
            status: 'pending',
          ),
        ];

        when(() => mockBloc.state).thenReturn(
          WaitlistLoaded(
            rentalWaitlist: [],
            groupWaitlist: mockGroupWaitlist,
            date: testDate,
          ),
        );

        await tester.pumpWidget(buildWidget());

        // Изначально мы на вкладке "Аренда", и она пуста
        expect(find.text('Пока никого нет'), findsOneWidget);

        // Переключаемся на вкладку "В группу"
        await tester.tap(find.text('В группу'));
        await tester
            .pumpAndSettle(); // Ждем завершения анимации переключения вкладок

        // Проверяем, что отобразились специфичные для группы данные
        expect(find.text('Анна Смирнова'), findsOneWidget);
        expect(find.textContaining('+79998887766'), findsOneWidget);
        expect(
          find.textContaining('Возраст: 18+, Уровень: Продвинутый'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Коммент: Хочет в вечернюю группу'),
          findsOneWidget,
        );
      },
    );
  });
}
