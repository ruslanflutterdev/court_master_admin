import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/auth/data/repositories/auth_repository.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('AuthBloc Tests', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepo;

    setUp(() {
      mockAuthRepo = MockAuthRepository();
      authBloc = AuthBloc(repository: mockAuthRepo);
    });

    tearDown(() {
      authBloc.close();
    });

    test('Начальное состояние должно быть AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'Успешный логин: [AuthLoading, AuthAuthenticated]',
      build: () {
        when(() => mockAuthRepo.login('admin@test.com', '12345678'))
            .thenAnswer((_) async => {'token': 'fake_jwt_token', 'role': 'admin'});
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('admin@test.com', '12345678')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Неверный пароль: [AuthLoading, AuthError]',
      build: () {
        when(() => mockAuthRepo.login('admin@test.com', 'wrong'))
            .thenThrow(Exception('Invalid credentials'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('admin@test.com', 'wrong')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
        'Логаут (Выход): [AuthUnauthenticated]',
      build: () {
        when(() => mockAuthRepo.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutEvent()),
      expect: () => [
        isA<AuthUnauthenticated>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'Проверка авторизации (есть токен): [AuthLoading, AuthAuthenticated]',
      build: () {
        when(() => mockAuthRepo.checkAuth())
            .thenAnswer((_) async => {'token': 'saved_token', 'role': 'admin'});
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthEvent()),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthAuthenticated>(),
      ],
    );
  });
}