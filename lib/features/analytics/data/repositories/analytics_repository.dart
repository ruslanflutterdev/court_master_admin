import '../../../../core/api/api_client.dart';
import '../models/analytics_model.dart';

class AnalyticsRepository {
  final ApiClient apiClient;

  AnalyticsRepository({required this.apiClient});

  Future<AnalyticsModel> getDashboardData() async {
    final response = await apiClient.dio.get('/analytics');
    return AnalyticsModel.fromJson(response.data);
  }
}
