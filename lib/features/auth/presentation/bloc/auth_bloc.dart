import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final authData = await repository.login(event.email, event.password);
        // Передаем и токен, и роль!
        emit(
          AuthAuthenticated(token: authData['token']!, role: authData['role']!),
        );
      } catch (e) {
        emit(AuthError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await repository.logout();
      emit(AuthUnauthenticated());
    });

    on<CheckAuthEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final authData = await repository.checkAuth();
        if (authData != null) {
          emit(
            AuthAuthenticated(
              token: authData['token']!,
              role: authData['role']!,
            ),
          );
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });
  }
}
