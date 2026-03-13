import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/forms/schedule_event_type_selector.dart';

void main() {
  testWidgets('ScheduleEventTypeSelector отображает все 5 типов событий', (
    tester,
  ) async {
    String selectedValue = 'group';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ScheduleEventTypeSelector(
            selectedType: selectedValue,
            onChanged: (val) {
              selectedValue = val;
            },
          ),
        ),
      ),
    );

    // Проверяем, что выбранное значение отображается
    expect(find.text('Групповая тренировка'), findsOneWidget);

    // Открываем список
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    // Проверяем, что в списке есть блокирующие типы из Шага 4
    expect(find.text('Аренда корта').last, findsOneWidget);
    expect(find.text('Индивидуальная тренировка').last, findsOneWidget);
    expect(find.text('🏆 Турнир (Блокировка)').last, findsOneWidget);
    expect(find.text('🔧 Техобслуживание (Блокировка)').last, findsOneWidget);

    // Выбираем турнир
    await tester.tap(find.text('🏆 Турнир (Блокировка)').last);
    await tester.pumpAndSettle();

    // Проверяем, что onChanged отработал
    expect(selectedValue, 'tournament');
  });
}
