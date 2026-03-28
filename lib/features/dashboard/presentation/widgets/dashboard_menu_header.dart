import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'user_info_card.dart';
import 'sidebar_calendar.dart';

class DashboardMenuHeader extends StatelessWidget {
  final int currentIndex;

  const DashboardMenuHeader({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Карточка пользователя (Имя/Фамилия + Logout)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticated) {
                  return UserInfoCard(state: state);
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),
            // 2. Логотип и Название
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_tennis, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text(
                  'CourtMaster',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            // 3. Календарь (только для таба Расписание)
            if (currentIndex == 1) ...[
              const SizedBox(height: 12),
              const SidebarCalendar(),
            ],
          ],
        ),
      ),
    );
  }
}
