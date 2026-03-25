import 'package:flutter/material.dart';

class DashboardMobileView extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final List<Widget> tabs;

  const DashboardMobileView({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: onTabSelected,
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
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Группы'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_search),
            label: 'Клиенты',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Касса',
          ),
        ],
      ),
    );
  }
}
