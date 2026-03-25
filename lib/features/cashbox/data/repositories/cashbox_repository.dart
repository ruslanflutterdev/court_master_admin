import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';

class CashboxRepository {
  final ApiClient apiClient;

  CashboxRepository(this.apiClient);

  Future<Map<String, dynamic>> openShift() async {
    try {
      final response = await apiClient.dio.post('/transactions/shift/open');
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 && e.response?.data['shift'] != null) {
        return e.response?.data['shift'];
      }
      throw Exception(e.response?.data['message'] ?? 'Ошибка открытия смены');
    }
  }

  Future<Map<String, dynamic>> closeShift() async {
    try {
      final response = await apiClient.dio.post('/transactions/shift/close');
      return response.data['shift'] ?? response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка закрытия смены');
    }
  }

  Future<Map<String, dynamic>> getShiftStatus() async {
    try {
      final response = await apiClient.dio.get('/transactions/shift/active');
      // Если бэк вернул данные, значит смена открыта
      return {...response.data, 'isOpen': true};
    } on DioException catch (e) {
      // Если 404, значит активной смены нет (закрыта)
      if (e.response?.statusCode == 404) {
        return {
          'isOpen': false,
          'totalCash': 0,
          'totalCard': 0,
          'openedAt': '-',
        };
      }
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка получения статуса смены',
      );
    }
  }
}
