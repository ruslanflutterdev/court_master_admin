import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/groups/data/models/group_model.dart';

void main() {
  group('GroupModel Tests', () {
    test('Успешный парсинг GroupModel из JSON со всеми обязательными полями', () {
      final json = {
        'id': 'g1',
        'name': 'Детская группа',
        'scheduleText': 'Пн, Ср, Пт 18:00',
        'coachId': 'c1',
      };

      final result = GroupModel.fromJson(json);

      expect(result.id, 'g1');
      expect(result.name, 'Детская группа');
      expect(result.scheduleText, 'Пн, Ср, Пт 18:00');
      expect(result.coachId, 'c1');
      expect(result.coach, null);
      expect(result.students, isEmpty);
    });

    test('Парсинг JSON с отсутствующими полями (проверка дефолтных значений)', () {
      final json = {
        'id': 'g2',
        'name': 'Взрослые PRO',
      };

      final result = GroupModel.fromJson(json);

      expect(result.id, 'g2');
      expect(result.name, 'Взрослые PRO');
      expect(result.scheduleText, '');
      expect(result.coachId, '');
      expect(result.coach, null);
      expect(result.students, isEmpty);
    });
  });
}