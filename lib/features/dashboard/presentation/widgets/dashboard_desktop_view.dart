import 'package:flutter/material.dart';

import 'dashboard_menu_header.dart';

class DashboardDesktopView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final List<Widget> tabs;

  const DashboardDesktopView({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            minExtendedWidth: 280,
            backgroundColor: Colors.white,
            indicatorColor: Colors.green.shade100,
            selectedIndex: currentIndex,
            onDestinationSelected: onTabSelected,
            leading: DashboardMenuHeader(currentIndex: currentIndex),
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
                selectedIcon: Icon(Icons.calendar_month, color: Colors.green),
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
                selectedIcon: Icon(Icons.person_search, color: Colors.green),
                label: Text(
                  'Клиенты',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.black12),
          Expanded(
            child: IndexedStack(index: currentIndex, children: tabs),
          ),
        ],
      ),
    );
  }
}
