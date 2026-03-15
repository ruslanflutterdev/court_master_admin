import '../models/user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});
}

abstract class AuthRepository {
  Future<AuthResponse> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> checkAuth();
}
