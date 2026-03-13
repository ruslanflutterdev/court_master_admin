import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    // 1. Логин
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // Теперь repository.login возвращает объект AuthResponse
        final authResponse = await repository.login(
          event.email,
          event.password,
        );

        // Передаем модель юзера в стейт
        emit(AuthAuthenticated(user: authResponse.user));
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    // 2. Выход
    on<LogoutEvent>((event, emit) async {
      await repository.logout();
      emit(AuthUnauthenticated());
    });

    on<CheckAuthEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.checkAuth();

        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });
  }
}
