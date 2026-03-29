import 'package:court_master_admin/features/schedule/data/models/attendance_student_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../models/court_model.dart';
import '../models/schedule_event_model.dart';
import '../models/waitlist_model.dart';

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

  Future<void> updateEvent(String id, Map<String, dynamic> eventData) async {
    try {
      await apiClient.put('/events/$id', data: eventData);
    } catch (e) {
      throw Exception('Не удалось обновить событие: $e');
    }
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    await apiClient.dio.post('/events', data: data);
  }

  Future<void> cancelEvent(String id) async {
    try {
      await apiClient.dio.post('/events/$id/cancel');
    } catch (e) {
      throw Exception('Не удалось отменить событие: $e');
    }
  }

  Future<void> cancelEventSeries(String seriesId) async {
    try {
      await apiClient.dio.post('/events/series/$seriesId/cancel');
    } catch (e) {
      throw Exception('Не удалось отменить серию событий: $e');
    }
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

  Future<List<WaitlistModel>> getWaitlists({
    required String type,
    DateTime? date,
  }) async {
    final queryParams = <String, dynamic>{'type': type};
    if (date != null) {
      queryParams['date'] =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }

    final response = await apiClient.dio.get(
      '/waitlists',
      queryParameters: queryParams,
    );
    return (response.data as List)
        .map((json) => WaitlistModel.fromJson(json))
        .toList();
  }

  Future<void> addToWaitlist(Map<String, dynamic> waitlistData) async {
    await apiClient.dio.post('/waitlists', data: waitlistData);
  }

  Future<void> removeFromWaitlist(String id) async {
    await apiClient.dio.delete('/waitlists/$id');
  }
}
