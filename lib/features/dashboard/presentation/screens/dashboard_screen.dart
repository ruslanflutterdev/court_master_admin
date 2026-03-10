import 'package:flutter/material.dart';
import '../../../employees/presentation/screens/admin_employees_tab.dart';
import '../../../groups/presentation/screens/admin_groups_tab.dart';
import '../../../schedule/presentation/screens/admin_schedule_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 1;

  final List<Widget> _tabs = [
    const AdminScheduleTab(),
    const AdminEmployeesTab(),
    const AdminGroupsTab(),
    const Center(child: Text('Здесь будет Профиль (Выход)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Расписание',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Сотрудники',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Группы'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
