import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', data['token']);

      return data['user'];

    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка сети или сервера');
    } catch (e) {
      throw Exception('Непредвиденная ошибка: $e');
    }
  }

  @override
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}