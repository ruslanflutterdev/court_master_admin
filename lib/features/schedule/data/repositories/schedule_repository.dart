import 'package:court_master_admin/features/schedule/data/models/attendance_student_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../models/court_model.dart';
import '../models/schedule_event_model.dart';

class ScheduleRepository {
  final ApiClient apiClient;

  ScheduleRepository(this.apiClient);

  Future<List<CourtModel>> getCourts() async {
    final response = await apiClient.dio.get('/courts');
    return (response.data as List)
        .map((json) => CourtModel.fromJson(json))
        .toList();
  }

  Future<void> createCourt(String name) async {
    await apiClient.dio.post('/courts', data: {'name': name});
  }

  Future<void> updateCourt(String id, String name) async {
    await apiClient.dio.put('/courts/$id', data: {'name': name});
  }

  Future<List<ScheduleEventModel>> getEvents({
    String? startDate,
    String? endDate,
  }) async {
    final response = await apiClient.dio.get(
      '/events',
      queryParameters: {'startDate': ?startDate, 'endDate': ?endDate},
    );
    return (response.data as List)
        .map((json) => ScheduleEventModel.fromJson(json))
        .toList();
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    await apiClient.dio.post('/events', data: data);
  }

  Future<void> deleteEvent(String id) async {
    await apiClient.dio.delete('/events/$id');
  }

  Future<List<AttendanceStudentModel>> getEventAttendance(
    String eventId,
  ) async {
    try {
      final response = await apiClient.dio.get('/events/$eventId/attendance');
      return (response.data as List)
          .map((json) => AttendanceStudentModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка загрузки журнала');
    }
  }

  // Отметить ученика на занятии
  Future<void> markAttendance(
    String eventId,
    String studentId,
    int status,
  ) async {
    try {
      await apiClient.dio.post(
        '/events/$eventId/attendance',
        data: {'studentId': studentId, 'status': status},
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Ошибка при сохранении отметки',
      );
    }
  }
}
