import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl(this.apiClient);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data['token'] as String;
      final user = UserModel.fromJson(response.data['user']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      await prefs.setString('user_role', user.role);
      await prefs.setString('user_id', user.id);

      return AuthResponse(token: token, user: user);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка авторизации');
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_role');
    await prefs.remove('user_id');
  }

  @override
  Future<UserModel?> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null || token.isEmpty) return null;

    try {
      final role = prefs.getString('user_role') ?? 'CLIENT';
      final id = prefs.getString('user_id') ?? '';

      return UserModel(
        id: id,
        firstName: '',
        lastName: '',
        email: '',
        role: role,
      );
    } catch (e) {
      return null;
    }
  }
}
