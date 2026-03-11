import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<Map<String, String>> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final role = response.data['user']['role'] as String;

      final prefs = await SharedPreferences.getInstance();
      // Сохраняем токен под правильным ключом, который ждет ApiClient
      await prefs.setString('jwt_token', token);
      await prefs.setString('user_role', role);

      return {'token': token, 'role': role};
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка авторизации');
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_role');
  }

  @override
  Future<Map<String, String>?> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    final role = prefs.getString('user_role');

    if (token != null && token.isNotEmpty && role != null) {
      return {'token': token, 'role': role};
    }
    return null;
  }
}
