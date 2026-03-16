import '../../../../core/api/api_client.dart';
import '../models/coach_model.dart';

class EmployeesRepository {
  final ApiClient apiClient;

  EmployeesRepository({required this.apiClient});

  Future<List<CoachModel>> getCoaches() async {
    final response = await apiClient.get('/employees/coaches');
    return (response.data as List).map((e) => CoachModel.fromJson(e)).toList();
  }

  Future<void> createCoach(Map<String, dynamic> coachData) async {
    await apiClient.post('/employees', data: coachData);
  }
}
