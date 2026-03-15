import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/analytics/data/models/analytics_model.dart';

void main() {
  group('AnalyticsModel Tests', () {
    test('Успешный парсинг аналитики из JSON со всеми полями', () {
      // 1. Создаем JSON, который точно совпадает с полями из твоего бэкенда
      final json = {
        'clientsCount': 150,
        'totalDebt': 5000,
        'monthlyRevenue': 120000,
        'activeSubsCount': 45,
      };

      // 2. Парсим
      final result = AnalyticsModel.fromJson(json);

      // 3. Проверяем твои реальные поля
      expect(result.clientsCount, 150);
      expect(result.totalDebt, 5000);
      expect(result.monthlyRevenue, 120000);
      expect(result.activeSubsCount, 45);
    });

    test('Парсинг пустого JSON (проверка нулей по умолчанию)', () {
      final json = <String, dynamic>{}; // Пустой JSON

      final result = AnalyticsModel.fromJson(json);

      // Проверяем, что вместо null подставились нули (как у тебя прописано в fromJson)
      expect(result.clientsCount, 0);
      expect(result.totalDebt, 0);
      expect(result.monthlyRevenue, 0);
      expect(result.activeSubsCount, 0);
    });
  });
}
