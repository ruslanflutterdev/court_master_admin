import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/groups/presentation/screens/group_details_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/group-details/:id',
      builder: (context, state) {
        final groupId = state.pathParameters['id']!;
        return GroupDetailsScreen(groupId: groupId);
      },
    ),
  ],
);
