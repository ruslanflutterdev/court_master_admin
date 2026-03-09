import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/student_model.dart';

class StudentsRepository {
  final ApiClient apiClient;

  StudentsRepository(this.apiClient);

  Future<List<StudentModel>> getStudents() async {
    try {
      final response = await apiClient.dio.get('/students');
      final List data = response.data;
      return data.map((json) => StudentModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка загрузки учеников');
    }
  }
}