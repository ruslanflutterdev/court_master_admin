import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';

void main() {
  group('CoachModel Tests', () {
    test('Успешный парсинг из JSON со всеми полями', () {
      final json = {
        'id': '1',
        'firstName': 'Иван',
        'lastName': 'Иванов',
        'email': 'ivan@test.com',
        'role': 'tennisCoach',
        'phone': '+79991234567',
        'qualification': 'МСМК',
        'specialization': 'Теннис',
        'rating': 4.8,
        'salaryType': 'hourly',
        // Передаем строку, чтобы проверить нашу новую супер-защиту от type mismatch
        'salaryRate': '5000',
      };

      final model = CoachModel.fromJson(json);

      expect(model.id, '1');
      expect(model.firstName, 'Иван');
      expect(model.lastName, 'Иванов');
      expect(model.email, 'ivan@test.com');
      expect(model.role, 'tennisCoach');
      expect(model.phone, '+79991234567');
      expect(model.qualification, 'МСМК');
      expect(model.specialization, 'Теннис');
      expect(model.rating, 4.8);
      expect(model.salaryType, 'hourly');
      expect(model.salaryRate, 5000); // Должно корректно стать числом int
    });

    test(
      'Успешный парсинг из JSON, если пришло только Имя (без фамилии, email и телефона)',
      () {
        final json = {'id': '2', 'firstName': 'Петр'};

        final model = CoachModel.fromJson(json);

        expect(model.id, '2');
        expect(model.firstName, 'Петр');
        expect(model.lastName, ''); // Ожидаем пустую строку, а не краш
        expect(model.email, '');
        expect(model.role, 'tennisCoach'); // Подставит значение по умолчанию
        expect(model.phone, null);
        expect(model.specialization, null);
        expect(model.rating, 5.0); // Значение по умолчанию
        expect(model.salaryRate, null);
      },
    );

    test('Проверка toJson', () {
      final model = CoachModel(
        id: '3',
        firstName: 'Анна',
        lastName: 'Сидорова',
        email: 'anna@test.com',
        role: 'tennisCoach',
        phone: '+70001112233',
        qualification: 'КМС',
        specialization: 'Дети',
        rating: 5.0,
        salaryType: 'percentage',
        salaryRate: 40,
      );

      final json = model.toJson();

      expect(json['id'], '3');
      expect(json['firstName'], 'Анна');
      expect(json['lastName'], 'Сидорова');
      expect(json['email'], 'anna@test.com');
      expect(json['phone'], '+70001112233');
      expect(json['qualification'], 'КМС');
      expect(json['specialization'], 'Дети');
      expect(json['rating'], 5.0);
      expect(json['salaryType'], 'percentage');
      expect(json['salaryRate'], 40);
    });
  });
}
