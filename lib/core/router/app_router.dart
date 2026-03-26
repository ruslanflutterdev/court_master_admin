import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/coach_dashboard/presentation/screens/coach_dashboard_screen.dart';
import '../../features/clients/presentation/screens/admin_client_details_screen.dart';
import '../../features/groups/presentation/screens/group_details_screen.dart';

class AppRouter {
  final AuthBloc authBloc;

  AppRouter(this.authBloc);

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authBloc.stream),

    redirect: (context, state) {
      final authState = authBloc.state;
      final isLoggingIn = state.matchedLocation == '/login';

      if (authState is AuthInitial ||
          authState is AuthLoading ||
          authState is AuthUnauthenticated) {
        return isLoggingIn ? null : '/login';
      }

      if (authState is AuthAuthenticated) {
        if (isLoggingIn || state.matchedLocation == '/') {
          final role = authState.user.role;

          if (role == AppRoles.coach) {
            return '/coach-dashboard';
          } else if ([
            AppRoles.superAdmin,
            AppRoles.headAdmin,
            AppRoles.admin,
          ].contains(role)) {
            return '/dashboard';
          } else {
            return '/login';
          }
        }
      } else if (authState is AuthUnauthenticated) {
        if (!isLoggingIn) {
          return '/login';
        }
      }

      return null;
    },

    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/coach-dashboard',
        builder: (context, state) => const CoachDashboardScreen(),
      ),
      GoRoute(
        path: '/client-details/:id',
        builder: (context, state) =>
            AdminClientDetailsScreen(clientId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/group-details/:id',
        builder: (context, state) =>
            GroupDetailsScreen(groupId: state.pathParameters['id']!),
      ),
    ],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
