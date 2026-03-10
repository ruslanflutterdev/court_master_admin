import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../../analytics/presentation/screens/admin_analytics_tab.dart'; // <--- НОВЫЙ ИМПОРТ
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/screens/admin_clients_tab.dart';
import '../../../employees/presentation/screens/admin_employees_tab.dart';
import '../../../groups/presentation/screens/admin_groups_tab.dart';
import '../../../schedule/presentation/screens/admin_schedule_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0; // Начинаем с 0 (Главная)

  final List<Widget> _tabs = [
    const AdminAnalyticsTab(), // <--- Наша новая аналитика на 1-м месте
    const AdminScheduleTab(),
    const AdminEmployeesTab(),
    const AdminGroupsTab(),
    const AdminClientsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ClientsBloc>()..add(LoadClientsEvent()),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _tabs),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed, // Чтобы иконки не "прыгали"
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Главная',
            ), // <--- Добавили кнопку
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Расписание',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Сотрудники',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Группы'),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_search),
              label: 'Клиенты',
            ),
          ],
        ),
      ),
    );
  }
}
