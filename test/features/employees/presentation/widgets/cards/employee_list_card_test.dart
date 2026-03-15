import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/employees/presentation/widgets/cards/employee_list_card.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';

void main() {
  group('EmployeeListCard Widget Tests', () {
    testWidgets('Должен корректно отображать все данные тренера', (
      WidgetTester tester,
    ) async {
      // 1. Создаем тестовые данные
      final coach = CoachModel(
        id: '1',
        firstName: 'Роджер',
        lastName: 'Федерер',
        email: 'roger@test.com',
        role: 'tennisCoach',
        specialization: 'Профессионалы и взрослые',
        rating: 4.9,
        phone: '+79991234567',
      );

      bool isTapped = false;

      // 2. Отрисовываем виджет
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmployeeListCard(coach: coach, onTap: () => isTapped = true),
          ),
        ),
      );

      // 3. Проверяем, что все тексты есть на экране
      expect(find.text('Роджер Федерер'), findsOneWidget);
      expect(find.text('Профессионалы и взрослые'), findsOneWidget);
      expect(find.text('4.9'), findsOneWidget);
      expect(find.text('+79991234567'), findsOneWidget);

      // 4. Проверяем иконки
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.phone), findsOneWidget);

      // 5. Имитируем нажатие на карточку
      await tester.tap(find.byType(EmployeeListCard));
      await tester.pump();

      // 6. Проверяем, что коллбек сработал
      expect(isTapped, isTrue);
    });
  });
}
