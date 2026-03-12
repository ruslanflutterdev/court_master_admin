import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/schedule/data/models/schedule_event_model.dart';

void main() {
  group('ScheduleEventModel Tests', () {
    test('Успешный парсинг события (Аренда корта) из JSON', () {
      final json = {
        'id': 'e1',
        'type': 'rent',
        'date': '2026-03-12T00:00:00.000Z',
        'startTime': '10:00',
        'endTime': '11:30',
        'colorHex': '#FF0000',
        'courtId': 'c1',
        'clientName': 'Иван',
        'clientPhone': '+79991234567',
      };

      final result = ScheduleEventModel.fromJson(json);

      expect(result.id, 'e1');
      expect(result.eventType, 'rent');
      expect(result.date, DateTime.parse('2026-03-12T00:00:00.000Z'));

      // Проверяем, что парсер времени отработал верно!
      expect(result.startTime, const TimeOfDay(hour: 10, minute: 0));
      expect(result.endTime, const TimeOfDay(hour: 11, minute: 30));

      expect(result.color, '#FF0000');
      expect(result.courtId, 'c1');
      expect(result.clientName, 'Иван');

      expect(result.groupId, null);
      expect(result.coachId, null);
    });
  });
}