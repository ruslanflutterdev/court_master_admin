import '../models/group_model.dart';
import '../../../../core/api/api_client.dart';
import 'package:dio/dio.dart';

class GroupsRepository {
  final ApiClient apiClient;

  GroupsRepository(this.apiClient);

  Future<List<GroupModel>> getGroups() async {
    try {
      final response = await apiClient.dio.get('/groups');
      final List data = response.data;
      return data.map((json) => GroupModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка загрузки групп');
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }

  // Заготовка для создания группы (используем на следующем шаге)
  Future<void> createGroup(String name, String scheduleText, String coachId) async {
    try {
      await apiClient.dio.post('/groups', data: {
        'name': name,
        'scheduleText': scheduleText,
        'coachId': coachId,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка создания группы');
    }
  }
}