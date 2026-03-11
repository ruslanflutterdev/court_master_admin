import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';
import '../../../schedule/presentation/bloc/schedule_event.dart';
import '../../../schedule/presentation/bloc/schedule_state.dart';

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
            leading: _buildMenuHeader(context),
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

  Widget _buildMenuHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sports_tennis, color: Colors.green, size: 36),
              SizedBox(width: 12),
              Text(
                'CourtMaster',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (currentIndex == 1) ...[
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
                        onDateChanged: (date) => context
                            .read<ScheduleBloc>()
                            .add(LoadScheduleData(date)),
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
    );
  }
}
