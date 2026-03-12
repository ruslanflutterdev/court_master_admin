import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/main.dart' as app;
import 'package:integration_test/integration_test.dart';

void main() {
  // Инициализируем драйвер для интеграционных тестов
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('E2E Тесты приложения', () {
    testWidgets('Сценарий: Успешный логин и загрузка Dashboard', (WidgetTester tester) async {
      // 1. Запускаем реальное приложение (вызывает твою функцию main)
      app.main();

      // Ждем, пока приложение полностью отрисуется (сплеш-скрин, инициализация)
      await tester.pumpAndSettle();

      // 2. Проверяем, что мы находимся на экране логина
      expect(find.text('CourtMaster CRM'), findsOneWidget);

      // 3. Робот находит поля ввода (он очистит их и введет данные заново)
      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      await tester.enterText(emailField, 'admin@test.com');
      await tester.enterText(passwordField, '12345678');

      // Прячем клавиатуру
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // 4. Робот нажимает на кнопку "Войти"
      await tester.tap(find.text('Войти'));

      // Запускаем перерисовку экрана (чтобы появилась крутилка)
      await tester.pump();

      // 5. ЖЕСТКАЯ ПАУЗА. Ждем 3 секунды, чтобы реальный HTTP-запрос точно долетел
      // до бэкенда, токен сохранился, и сработала навигация.
      await Future.delayed(const Duration(seconds: 3));

      // Дожидаемся окончания всех анимаций перехода на новый экран
      await tester.pumpAndSettle();

      // 6. Проверяем, что мы успешно зашли и оказались на главном экране!
      expect(find.text('Главная'), findsWidgets);
      expect(find.text('Расписание'), findsWidgets);
    });
  });
}