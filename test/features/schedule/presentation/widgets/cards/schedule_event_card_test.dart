import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/cards/schedule_event_card.dart';
import 'package:court_master_admin/features/schedule/data/models/schedule_event_model.dart';

void main() {
  group('ScheduleEventCard Drag & Drop Tests', () {
    late ScheduleEventModel testEvent;

    setUp(() {
      testEvent = ScheduleEventModel(
        id: '1',
        courtId: 'c1',
        date: DateTime.now(),
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 11, minute: 0),
        eventType: 'rent',
        colorHex: 'blue',
        price: 1000,
        status: 'active',
        isPaid: false,
      );
    });

    testWidgets('Будущее событие ДОЛЖНО иметь виджет LongPressDraggable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                ScheduleEventCard(
                  event: testEvent,
                  isPastDate: false, // Событие в будущем (или сегодня)
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Проверяем, что виджет перетаскивания присутствует
      expect(
        find.byType(LongPressDraggable<ScheduleEventModel>),
        findsOneWidget,
      );
    });

    testWidgets('Прошедшее событие НЕ ДОЛЖНО иметь виджет LongPressDraggable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                ScheduleEventCard(
                  event: testEvent,
                  isPastDate: true, // Событие в прошлом
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // Проверяем, что виджета перетаскивания НЕТ (нельзя переносить историю)
      expect(find.byType(LongPressDraggable<ScheduleEventModel>), findsNothing);
      // Но сама карточка (GestureDetector) должна быть на месте
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
