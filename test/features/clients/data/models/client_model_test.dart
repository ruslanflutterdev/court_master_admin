import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/clients/data/models/client_model.dart';

void main() {
  group('ClientModel Tests', () {
    test('Успешный парсинг ClientModel из JSON со всеми полями', () {
      final json = {
        'id': 'c1',
        'firstName': 'Иван',
        'lastName': 'Иванов',
        'email': 'ivan@test.com',
        'phone': '+79991234567',
        'balance': 1500,
        '_count': {'subscriptions': 2},
        'subscriptions': [], // Пустые списки для теста
        'payments': [],
      };

      final result = ClientModel.fromJson(json);

      expect(result.id, 'c1');
      expect(result.firstName, 'Иван');
      expect(result.balance, 1500);
      expect(result.activeSubscriptionsCount, 2);
      expect(result.phone, '+79991234567');
      expect(result.subscriptions, isEmpty);
      expect(result.payments, isEmpty);
    });

    test('Парсинг JSON с отсутствующими опциональными полями', () {
      final json = {
        'id': 'c2',
        'firstName': 'Анна',
        'lastName': 'Смирнова',
        'email': 'anna@test.com',
        // balance, _count, phone, subscriptions, payments специально не передаем
      };

      final result = ClientModel.fromJson(json);

      expect(result.id, 'c2');
      expect(result.balance, 0); // Проверяем, что подставился 0 по умолчанию
      expect(result.activeSubscriptionsCount, 0); // Подставился 0
      expect(result.phone, null); // Опциональное поле
      expect(result.subscriptions, null);
      expect(result.payments, null);
    });
  });
}