import 'package:court_master_admin/features/schedule/presentation/widgets/forms/schedule_form_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/create_schedule_event_sheet.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/forms/schedule_group_form.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/forms/schedule_rent_form.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/forms/schedule_event_type_selector.dart';
import 'package:court_master_admin/features/groups/data/models/group_model.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';

void main() {
  group('CreateScheduleEventSheet Widget Tests', () {
    final dummyGroups = [
      GroupModel(
        id: 'g1',
        name: 'Группа 1',
        coachId: 'c1',
        scheduleText: 'Пн 10:00',
      ),
    ];
    final dummyCoaches = [
      CoachModel(id: 'c1', firstName: 'Иван', phone: '123'),
    ];

    Widget buildTestWidget({OnSaveEvent? onSave}) {
      return MaterialApp(
        home: Scaffold(
          body: CreateScheduleEventSheet(
            courtId: 'c1',
            startHour: 10,
            date: DateTime(2026, 3, 12),
            groups: dummyGroups,
            coaches: dummyCoaches,
            onSave:
                onSave ??
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
                }) {},
          ),
        ),
      );
    }

    testWidgets('По умолчанию отображается форма группы', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      expect(find.byType(ScheduleGroupForm), findsOneWidget);
    });

    testWidgets('Смена типа на Аренду', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      final dropdown = find.descendant(
        of: find.byType(ScheduleEventTypeSelector),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      await tester.tap(dropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Аренда корта').last);
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleRentForm), findsOneWidget);
    });

    testWidgets('Сохранение передает дефолтную регулярность (false, 1)', (
      tester,
    ) async {
      bool? savedIsRecurring;
      int? savedWeeks;

      await tester.pumpWidget(
        buildTestWidget(
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
                savedIsRecurring = isRecurring;
                savedWeeks = weeks;
              },
        ),
      );

      await tester.tap(find.text('Сохранить'));
      await tester.pump();

      expect(savedIsRecurring, false);
      expect(savedWeeks, 1);
    });
  });
}
