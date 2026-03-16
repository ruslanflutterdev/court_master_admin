import 'package:flutter_test/flutter_test.dart';
import 'package:court_master_admin/features/analytics/data/models/analytics_model.dart';

void main() {
  group('AnalyticsModel Tests', () {
    test('Успешный парсинг аналитики из JSON со всеми полями', () {
      final json = {
        'monthlyRevenue': 120000,
        'totalDebt': 50000,
        'totalClients': 150, // Ключ должен быть totalClients, а не clientsCount
        'activeSubsCount': 45,
        'revenueByCourt': [
          {'name': 'Корт 1', 'value': 70000.0},
        ],
        'revenueByCoach': [
          {'name': 'Тренер 1', 'value': 50000.0},
        ],
      };

      final model = AnalyticsModel.fromJson(json);

      expect(model.monthlyRevenue, 120000);
      expect(model.totalDebt, 50000);
      expect(model.clientsCount, 150); // Проверяем поле модели
      expect(model.activeSubsCount, 45);
      expect(model.revenueByCourt.first.name, 'Корт 1');
    });
  });
}
