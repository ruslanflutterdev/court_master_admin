import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/schedule/data/models/schedule_event_model.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/cards/schedule_event_card.dart';

import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';
import 'package:court_master_admin/features/auth/data/models/user_model.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Ставим роль ADMIN, чтобы работал Drag & Drop в тесте
    final dummyUser = UserModel(
      id: '1',
      email: 'admin@test.com',
      firstName: 'Admin',
      lastName: '',
      role: 'ADMIN',
    );
    when(
      () => mockAuthBloc.state,
    ).thenReturn(AuthAuthenticated(user: dummyUser));
  });

  // Добавили параметр allEvents (по умолчанию пустой список)
  Widget createWidgetUnderTest(
    ScheduleEventModel event,
    bool isPastDate, {
    List<ScheduleEventModel> allEvents = const [],
  }) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: Scaffold(
          body: Stack(
            children: [
              ScheduleEventCard(
                event: event,
                isPastDate: isPastDate,
                onTap: () {},
                // Передаем список событий. Если пустой - передаем хотя бы само событие.
                allEvents: allEvents.isEmpty ? [event] : allEvents,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final baseEvent = ScheduleEventModel(
    id: '1',
    eventType: 'rent',
    date: DateTime.now(),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    courtId: 'c1',
    clientName: 'Иван',
    colorHex: '#2196F3',
    price: 5000,
    status: 'active',
  );

  final canceledEvent = ScheduleEventModel(
    id: '2',
    eventType: 'rent',
    date: DateTime.now(),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    courtId: 'c1',
    clientName: 'Петр (Отмена)',
    colorHex: '#2196F3',
    price: 5000,
    status: 'canceled', // Отмененное событие
  );

  group('ScheduleEventCard Widget Tests', () {
    testWidgets(
      'Будущее активное событие ДОЛЖНО иметь виджет LongPressDraggable',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(baseEvent, false));

        expect(
          find.byType(LongPressDraggable<ScheduleEventModel>),
          findsOneWidget,
        );
      },
    );

    testWidgets('Прошедшее событие НЕ ДОЛЖНО иметь виджет LongPressDraggable', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(baseEvent, true));

      expect(find.byType(LongPressDraggable<ScheduleEventModel>), findsNothing);
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets(
      'Отмененное событие ДОЛЖНО быть обернуто в IgnorePointer и не иметь Draggable',
      (tester) async {
        await tester.pumpWidget(createWidgetUnderTest(canceledEvent, false));

        // Отмененное событие кликаться не должно (сквозной клик)
        expect(find.byType(IgnorePointer), findsOneWidget);
        // Двигать его тоже нельзя
        expect(
          find.byType(LongPressDraggable<ScheduleEventModel>),
          findsNothing,
        );
        // Проверяем, что текст зачеркнут
        final textWidget = tester.widget<Text>(find.text('Аренда'));
        expect(textWidget.style?.decoration, TextDecoration.lineThrough);
      },
    );

    testWidgets(
      'Активное событие поверх отмененного ДОЛЖНО рендериться корректно',
      (tester) async {
        // Передаем в allEvents оба события, чтобы сработала логика сужения карточки
        await tester.pumpWidget(
          createWidgetUnderTest(
            baseEvent,
            false,
            allEvents: [baseEvent, canceledEvent],
          ),
        );

        // Проверяем, что активное событие рендерится как draggable (наложение работает и не ломает виджет)
        expect(
          find.byType(LongPressDraggable<ScheduleEventModel>),
          findsOneWidget,
        );
      },
    );
  });
}
