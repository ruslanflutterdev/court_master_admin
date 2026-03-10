import '../models/coach_model.dart';
import '../../../../core/api/api_client.dart';
import 'package:dio/dio.dart';

class EmployeesRepository {
  final ApiClient apiClient;

  EmployeesRepository(this.apiClient);

  Future<List<CoachModel>> getCoaches() async {
    try {
      final response = await apiClient.dio.get('/employees/coaches');
      final List data = response.data;
      return data.map((json) => CoachModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка загрузки тренеров',
      );
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }
}
