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

  Future<List<ScheduleEventModel>> getEvents() async {
    final response = await apiClient.dio.get('/events');
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
}
