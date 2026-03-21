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

  Future<void> createGroup(Map<String, dynamic> groupData) async {
    try {
      await apiClient.dio.post('/groups', data: groupData);
    } catch (e) {
      throw Exception('Ошибка при создании группы: $e');
    }
  }

  // Получить детали одной группы
  Future<GroupModel> getGroupDetails(String groupId) async {
    try {
      final response = await apiClient.dio.get('/groups/$groupId');
      return GroupModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка загрузки группы');
    }
  }

  // Добавить ученика в группу
  Future<void> addStudentToGroup(String groupId, String studentId) async {
    try {
      await apiClient.dio.post(
        '/groups/$groupId/students',
        data: {'studentId': studentId},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка при добавлении ученика',
      );
    }
  }
}
