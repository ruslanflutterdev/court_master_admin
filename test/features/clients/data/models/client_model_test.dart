import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/clients/data/models/client_model.dart';

void main() {
  group('ClientModel и связанные модели', () {
    test('Успешный парсинг JSON с новыми полями (теги, уровень, история)', () {
      final json = {
        'id': '123',
        'firstName': 'Иван',
        'lastName': 'Иванов',
        'email': 'ivan@test.com',
        'phone': '+79991234567',
        'balance': 5000,
        '_count': {'subscriptions': 2},
        // НОВЫЕ ПОЛЯ
        'companyName': 'Газпром',
        'skillLevel': 'Любитель',
        'acquisitionSource': 'Instagram',
        'notes': 'Очень любит грунт',
        'tags': ['VIP', 'Корпорат'],
        // ИСТОРИЯ
        'attendances': [
          {
            'id': 'att_1',
            'status': 1, // Был
            'event': {
              'id': 'ev_1',
              'type': 'rent',
              'date': '2026-03-15T00:00:00.000Z',
              'startTime': '10:00',
              'endTime': '11:00',
              'colorHex': '#FFFFFF',
              'courtId': 'court_1',
              'court': {'name': 'Корт №1'},
              'coachId': 'coach_1',
              'coach': {'firstName': 'Роджер', 'lastName': 'Федерер'},
            },
          },
        ],
      };

      final client = ClientModel.fromJson(json);

      // Проверка базовых полей
      expect(client.id, '123');
      expect(client.firstName, 'Иван');
      expect(client.balance, 5000);
      expect(client.activeSubscriptionsCount, 2);

      // Проверка новых полей (ТЗ)
      expect(client.companyName, 'Газпром');
      expect(client.skillLevel, 'Любитель');
      expect(client.acquisitionSource, 'Instagram');
      expect(client.notes, 'Очень любит грунт');
      expect(client.tags, contains('VIP'));
      expect(client.tags.length, 2);

      // Проверка парсинга истории посещений (Attendance)
      expect(client.attendances, isNotNull);
      expect(client.attendances!.length, 1);

      final attendance = client.attendances!.first;
      expect(attendance.status, 1);
      expect(attendance.event.eventType, 'rent');
      expect(attendance.event.courtName, 'Корт №1');
      expect(
        attendance.event.coachFullName,
        'Роджер Федерер',
      ); // Проверка нашей новой склейки имени
    });

    test(
      'Парсинг JSON без опциональных списков и новых полей не вызывает ошибок',
      () {
        final json = {
          'id': '124',
          'firstName': 'Петр',
          'lastName': 'Петров',
          'email': 'petr@test.com',
          // balance и _count отсутствуют (проверка null safety)
        };

        final client = ClientModel.fromJson(json);

        expect(client.id, '124');
        expect(client.balance, 0); // Должен подставиться fallback 0
        expect(client.activeSubscriptionsCount, 0);
        expect(client.tags, isEmpty); // Должен быть пустой список, а не null
        expect(client.attendances, isNull);
      },
    );
  });
}
