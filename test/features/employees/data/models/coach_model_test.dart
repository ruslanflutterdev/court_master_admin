import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';

void main() {
  group('CoachModel Tests', () {

    test('Успешный парсинг из JSON со всеми полями', () {
      // 1. Arrange (Подготовка: имитируем полный ответ от бэкенда)
      final Map<String, dynamic> json = {
        'id': '123',
        'firstName': 'Иван',
        'lastName': 'Иванов',
        'email': 'ivan@test.com',
        'phone': '+79990001122',
      };

      // 2. Act (Действие: пытаемся создать модель через fromJson)
      final result = CoachModel.fromJson(json);

      // 3. Assert (Проверка: убеждаемся, что все поля легли куда надо)
      expect(result.id, '123');
      expect(result.firstName, 'Иван');
      expect(result.lastName, 'Иванов');
      expect(result.phone, '+79990001122');
    });

    test('Успешный парсинг из JSON, если пришло только Имя (без фамилии и телефона)', () {
      // 1. Arrange (Подготовка: имитируем неполный ответ)
      final Map<String, dynamic> json = {
        'id': '456',
        'firstName': 'Анна',
      };

      // 2. Act
      final result = CoachModel.fromJson(json);

      // 3. Assert
      expect(result.id, '456');
      expect(result.firstName, 'Анна');
      expect(result.lastName, null); // Проверяем, что null не вызывает краш!
      expect(result.phone, null);
    });

  });
}