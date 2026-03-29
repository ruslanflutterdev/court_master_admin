import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    // 1. Логин
    on<LoginRequested>((event, emit) async {
      emit(const AuthLoading());
      try {
        final authResponse = await repository.login(
          event.email,
          event.password,
        );

        emit(AuthAuthenticated(user: authResponse.user));
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    // 2. Выход
    on<LogoutEvent>((event, emit) async {
      await repository.logout();
      emit(const AuthUnauthenticated());
    });

    // 3. Проверка авторизации
    on<CheckAuthEvent>((event, emit) async {
      emit(const AuthLoading());
      try {
        final user = await repository.checkAuth();

        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      } catch (e) {
        emit(const AuthUnauthenticated());
      }
    });
  }
}
