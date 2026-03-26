import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/api_client.dart';
import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage _storage;

  AuthRepositoryImpl(this.apiClient, this._storage);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      print('--- Начало процесса login ---');
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      print('--- Ответ от сервера получен: ${response.statusCode} ---');

      var data = response.data;
      // Подстраховка для Web: если Dio вернул строку вместо Map
      if (data is String) {
        data = jsonDecode(data);
        print('--- Данные были строкой, распарсили в Map ---');
      }

      final token = data['token'] as String;
      final user = UserModel.fromJson(data['user']);
      print('--- Токен и юзер распарсены. Роль: ${user.role} ---');

      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'user_role', value: user.role);
      await _storage.write(key: 'user_id', value: user.id);
      print('--- Данные записаны в SecureStorage ---');

      return AuthResponse(token: token, user: user);
    } on DioException catch (e) {
      print('--- Ошибка Dio: ${e.response?.data} ---');
      throw Exception(e.response?.data['message'] ?? 'Ошибка авторизации');
    } catch (e, stack) {
      print('--- КРИТИЧЕСКАЯ ОШИБКА: $e ---');
      print(stack);
      throw Exception('Ошибка обработки данных: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_role');
    await _storage.delete(key: 'user_id');
  }

  @override
  Future<UserModel?> checkAuth() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) return null;

    try {
      final role = await _storage.read(key: 'user_role') ?? 'CLIENT';
      final id = await _storage.read(key: 'user_id') ?? '';

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
