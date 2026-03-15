import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/bloc/clients_event.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';
import '../../../schedule/presentation/bloc/schedule_event.dart';
import '../../../employees/presentation/bloc/employees_bloc.dart';
import '../../../employees/presentation/bloc/employees_event.dart';
import '../../../groups/presentation/bloc/groups_bloc.dart';
import '../../../groups/presentation/bloc/groups_event.dart';
import '../../../analytics/presentation/bloc/analytics_bloc.dart';
import '../../../analytics/presentation/bloc/analytics_event.dart';
import '../widgets/dashboard_mobile_view.dart';
import '../widgets/dashboard_desktop_view.dart';
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

  final List<Widget> _tabs = const [
    AdminAnalyticsTab(),
    AdminScheduleTab(),
    AdminEmployeesTab(),
    AdminGroupsTab(),
    AdminClientsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AnalyticsBloc>()..add(LoadAnalyticsEvent()),
        ),
        BlocProvider(
          create: (context) =>
              sl<ScheduleBloc>()..add(LoadScheduleData(DateTime.now())),
        ),
        BlocProvider(
          create: (context) => sl<EmployeesBloc>()..add(LoadEmployeesEvent()),
        ),
        BlocProvider(
          create: (context) => sl<GroupsBloc>()..add(LoadGroupsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<ClientsBloc>()..add(LoadClientsEvent()),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return DashboardMobileView(
              currentIndex: _currentIndex,
              onTabSelected: (i) => setState(() => _currentIndex = i),
              tabs: _tabs,
            );
          }
          return DashboardDesktopView(
            currentIndex: _currentIndex,
            onTabSelected: (i) => setState(() => _currentIndex = i),
            tabs: _tabs,
          );
        },
      ),
    );
  }
}
