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
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      var data = response.data;
      if (data is String) {
        data = jsonDecode(data);
      }

      final token = data['token'] as String;
      final user = UserModel.fromJson(data['user']);

      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'user_role', value: user.role);
      await _storage.write(key: 'user_id', value: user.id);
      await _storage.write(key: 'user_first_name', value: user.firstName);
      await _storage.write(key: 'user_last_name', value: user.lastName);
      await _storage.write(key: 'user_email', value: user.email);

      return AuthResponse(token: token, user: user);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Ошибка авторизации');
    } catch (e) {
      throw Exception('Ошибка обработки данных: $e');
    }
  }

  @override
  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'user_role');
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'user_first_name');
    await _storage.delete(key: 'user_last_name');
    await _storage.delete(key: 'user_email');
  }

  @override
  Future<UserModel?> checkAuth() async {
    final token = await _storage.read(key: 'auth_token');

    if (token == null || token.isEmpty) return null;

    try {
      final role = await _storage.read(key: 'user_role') ?? 'CLIENT';
      final id = await _storage.read(key: 'user_id') ?? '';
      final firstName = await _storage.read(key: 'user_first_name') ?? '';
      final lastName = await _storage.read(key: 'user_last_name') ?? '';
      final email = await _storage.read(key: 'user_email') ?? '';

      return UserModel(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        role: role,
      );
    } catch (e) {
      return null;
    }
  }
}
