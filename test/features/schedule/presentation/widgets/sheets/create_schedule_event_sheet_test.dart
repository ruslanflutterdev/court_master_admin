import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/create_schedule_event_sheet.dart';
import 'package:court_master_admin/features/schedule/data/models/schedule_event_model.dart';
import 'package:court_master_admin/features/groups/data/models/group_model.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';

void main() {
  group('CreateScheduleEventSheet Widget Tests', () {
    testWidgets(
      'Режим редактирования: подставляет старые данные и меняет тексты',
      (WidgetTester tester) async {
        // 1. Создаем "старое" событие, которое мы якобы редактируем
        final existingEvent = ScheduleEventModel(
          id: 'event-1',
          courtId: 'court-1',
          date: DateTime.now(),
          startTime: const TimeOfDay(hour: 14, minute: 0),
          endTime: const TimeOfDay(hour: 15, minute: 30),
          eventType: 'individual',
          colorHex: 'red',
          clientName: 'Илон Маск',
          clientPhone: '+123456789',
          price: 15000,
          status: 'active',
          isPaid: false,
        );

        bool isSaved = false;

        // 2. Отрисовываем виджет
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CreateScheduleEventSheet(
                courtId: 'court-1',
                startHour: 14,
                date: DateTime.now(),
                groups: const <GroupModel>[],
                coaches: const <CoachModel>[],
                existingEvent: existingEvent, // Передаем старое событие!
                onSave:
                    ({
                      required type,
                      required start,
                      required end,
                      required color,
                      required isRecurring,
                      required weeks,
                      groupId,
                      clientName,
                      clientPhone,
                      coachId,
                    }) {
                      isSaved = true;
                    },
              ),
            ),
          ),
        );

        // 3. Проверяем, что UI переключился в режим редактирования
        expect(
          find.text('Редактировать событие'),
          findsOneWidget,
        ); // Заголовок изменился
        expect(
          find.text('Сохранить изменения'),
          findsOneWidget,
        ); // Кнопка изменилась

        // Блок регулярности должен быть скрыт при редактировании
        expect(find.text('Повторять еженедельно'), findsNothing);

        // 4. Проверяем, что старые данные клиента подставились в поля ввода
        expect(find.text('Илон Маск'), findsOneWidget);
        expect(find.text('+123456789'), findsOneWidget);

        // 5. Имитируем нажатие на кнопку сохранения
        await tester.ensureVisible(find.text('Сохранить изменения'));
        await tester.tap(find.text('Сохранить изменения'));
        await tester.pump();

        // 6. Проверяем, что коллбек сработал
        expect(isSaved, isTrue);
      },
    );
  });
}
