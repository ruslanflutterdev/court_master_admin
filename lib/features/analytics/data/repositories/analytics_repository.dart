import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/analytics_model.dart';

class AnalyticsRepository {
  final ApiClient apiClient;

  AnalyticsRepository(this.apiClient);

  Future<AnalyticsModel> getDashboardData() async {
    try {
      final response = await apiClient.dio.get('/analytics/dashboard');
      return AnalyticsModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка загрузки аналитики',
      );
    }
  }
}
