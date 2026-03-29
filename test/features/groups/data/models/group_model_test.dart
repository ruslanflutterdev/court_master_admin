import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/groups/data/models/group_model.dart';

void main() {
  group('GroupModel Tests', () {
    test(
      'Успешный парсинг GroupModel из JSON со всеми обязательными полями',
      () {
        final json = {
          'id': 'g1',
          'name': 'Детская группа',
          'scheduleText': 'Пн, Ср, Пт 18:00',
          'coachId': 'c1',
          'type': 'TENNIS', // <-- ДОБАВИЛИ В ТЕСТ
          '_count': {'students': 8}, // <-- ДОБАВИЛИ В ТЕСТ
        };

        final result = GroupModel.fromJson(json);

        expect(result.id, 'g1');
        expect(result.name, 'Детская группа');
        expect(result.scheduleText, 'Пн, Ср, Пт 18:00');
        expect(result.coachId, 'c1');
        expect(result.type, 'TENNIS'); // <-- ПРОВЕРЯЕМ ТИП
        expect(result.studentsCount, 8); // <-- ПРОВЕРЯЕМ КОЛИЧЕСТВО
        expect(result.coach, null);
        expect(result.students, isEmpty);
      },
    );

    test(
      'Парсинг JSON с отсутствующими полями (проверка дефолтных значений)',
      () {
        final json = {'id': 'g2', 'name': 'Взрослые PRO'};

        final result = GroupModel.fromJson(json);

        expect(result.id, 'g2');
        expect(result.name, 'Взрослые PRO');
        expect(result.scheduleText, '');
        expect(result.coachId, '');
        expect(result.type, null); // <-- ПРОВЕРЯЕМ ДЕФОЛТ
        expect(result.studentsCount, 0); // <-- ПРОВЕРЯЕМ ДЕФОЛТ
        expect(result.coach, null);
        expect(result.students, isEmpty);
      },
    );
  });
}
