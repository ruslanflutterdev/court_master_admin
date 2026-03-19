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
        // 🚀 НОВЫЕ ПОЛЯ НАЛОГОВ
        'indivStateTaxRate': 10.0,
        'indivClubTaxRate': 40.0,
        'groupStateTaxRate': 0.0,
        'groupClubTaxRate': 30.0,
        'singleStateTaxRate': 5.0,
        'singleClubTaxRate': 50.0,
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
      // Проверяем новые поля
      expect(model.indivStateTaxRate, 10.0);
      expect(model.groupClubTaxRate, 30.0);
      expect(model.singleClubTaxRate, 50.0);
    });

    test('Успешный парсинг из JSON, если пришло только Имя', () {
      final json = {'id': '2', 'firstName': 'Петр'};

      final model = CoachModel.fromJson(json);

      expect(model.id, '2');
      expect(model.firstName, 'Петр');
      expect(model.lastName, '');
      expect(model.email, '');
      expect(model.role, 'tennisCoach');
      expect(model.phone, null);
      expect(model.specialization, null);
      expect(model.rating, 5.0);
      // Поля налогов должны иметь дефолт 0.0
      expect(model.indivStateTaxRate, 0.0);
    });

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
        // Передаем в конструктор новые поля
        indivStateTaxRate: 10.0,
        indivClubTaxRate: 40.0,
        groupStateTaxRate: 0.0,
        groupClubTaxRate: 30.0,
        singleStateTaxRate: 5.0,
        singleClubTaxRate: 50.0,
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
      // Проверяем конвертацию
      expect(json['indivStateTaxRate'], 10.0);
      expect(json['groupStateTaxRate'], 0.0);
      expect(json['singleClubTaxRate'], 50.0);
    });
  });
}
