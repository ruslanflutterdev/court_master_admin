import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart'; // <--- НОВЫЙ ИМПОРТ

import '../../../analytics/presentation/screens/admin_analytics_tab.dart';
import '../../../schedule/presentation/screens/admin_schedule_tab.dart';
import '../../../employees/presentation/screens/admin_employees_tab.dart';
import '../../../groups/presentation/screens/admin_groups_tab.dart';
import '../../../clients/presentation/screens/admin_clients_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1;

  final List<Widget> _tabs = [
    const AdminAnalyticsTab(),
    const AdminScheduleTab(),
    const AdminEmployeesTab(),
    const AdminGroupsTab(),
    const AdminClientsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    // Используем MultiBlocProvider, чтобы поднять оба стейта наверх!
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ClientsBloc>()..add(LoadClientsEvent()),
        ),
        BlocProvider(
          create: (context) =>
              sl<ScheduleBloc>()..add(LoadScheduleData(DateTime.now())),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          // --- 1. МОБИЛЬНЫЙ ИНТЕРФЕЙС (< 800px) ---
          if (constraints.maxWidth < 800) {
            return Scaffold(
              body: IndexedStack(index: _currentIndex, children: _tabs),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                onTap: (index) => setState(() => _currentIndex = index),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    label: 'Главная',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month),
                    label: 'Расписание',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.people),
                    label: 'Сотрудники',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.group),
                    label: 'Группы',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_search),
                    label: 'Клиенты',
                  ),
                ],
              ),
            );
          }

          // --- 2. ДЕСКТОП (>= 800px) ---
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: true,
                  minExtendedWidth: 280,
                  // Сделали чуть шире, чтобы влез календарь
                  backgroundColor: Colors.white,
                  indicatorColor: Colors.green.shade100,
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) =>
                      setState(() => _currentIndex = index),

                  // Логотип и КАЛЕНДАРЬ в шапке меню
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.sports_tennis,
                              color: Colors.green,
                              size: 36,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'CourtMaster',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        // Показываем календарь только если открыта вкладка "Расписание" (индекс 1)
                        if (_currentIndex == 1) ...[
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 260,
                            child: BlocBuilder<ScheduleBloc, ScheduleState>(
                              builder: (context, state) {
                                if (state is ScheduleLoaded) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors.green,
                                      ),
                                    ),
                                    child: CalendarDatePicker(
                                      initialDate: state.scheduleDate,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                      onDateChanged: (date) {
                                        context.read<ScheduleBloc>().add(
                                          LoadScheduleData(date),
                                        );
                                      },
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dashboard_outlined),
                      selectedIcon: Icon(Icons.dashboard, color: Colors.green),
                      label: Text(
                        'Главная',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.calendar_month_outlined),
                      selectedIcon: Icon(
                        Icons.calendar_month,
                        color: Colors.green,
                      ),
                      label: Text(
                        'Расписание',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people, color: Colors.green),
                      label: Text(
                        'Сотрудники',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.group_outlined),
                      selectedIcon: Icon(Icons.group, color: Colors.green),
                      label: Text(
                        'Группы',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_search_outlined),
                      selectedIcon: Icon(
                        Icons.person_search,
                        color: Colors.green,
                      ),
                      label: Text(
                        'Клиенты',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.black12,
                ),
                Expanded(
                  child: IndexedStack(index: _currentIndex, children: _tabs),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
