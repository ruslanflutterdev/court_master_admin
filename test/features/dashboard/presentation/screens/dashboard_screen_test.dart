import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';

import 'package:court_master_admin/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:court_master_admin/features/dashboard/presentation/widgets/dashboard_desktop_view.dart';
import 'package:court_master_admin/features/dashboard/presentation/widgets/dashboard_mobile_view.dart';

// Импорты ВСЕХ BLoC-ов из всех вкладок
import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';

import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_state.dart';

import 'package:court_master_admin/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:court_master_admin/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:court_master_admin/features/analytics/presentation/bloc/analytics_state.dart';

import 'package:court_master_admin/features/employees/presentation/bloc/employees_bloc.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_event.dart';
import 'package:court_master_admin/features/employees/presentation/bloc/employees_state.dart';

import 'package:court_master_admin/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_event.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_state.dart';

import 'package:court_master_admin/features/schedule/presentation/bloc/event_attendance_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/event_attendance_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/event_attendance_state.dart';

// 1. Создаем подделки
class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState> implements ClientsBloc {}
class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState> implements ScheduleBloc {}
class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState> implements AnalyticsBloc {}
class MockEmployeesBloc extends MockBloc<EmployeesEvent, EmployeesState> implements EmployeesBloc {}
class MockGroupsBloc extends MockBloc<GroupsEvent, GroupsState> implements GroupsBloc {}
class MockEventAttendanceBloc extends MockBloc<EventAttendanceEvent, EventAttendanceState> implements EventAttendanceBloc {}

// 2. Фейковые события
class FakeClientsEvent extends Fake implements ClientsEvent {}
class FakeScheduleEvent extends Fake implements ScheduleEvent {}
class FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}
class FakeEmployeesEvent extends Fake implements EmployeesEvent {}
class FakeGroupsEvent extends Fake implements GroupsEvent {}
class FakeEventAttendanceEvent extends Fake implements EventAttendanceEvent {}

void main() {
  late MockClientsBloc mockClientsBloc;
  late MockScheduleBloc mockScheduleBloc;
  late MockAnalyticsBloc mockAnalyticsBloc;
  late MockEmployeesBloc mockEmployeesBloc;
  late MockGroupsBloc mockGroupsBloc;
  late MockEventAttendanceBloc mockEventAttendanceBloc;

  setUpAll(() {
    registerFallbackValue(FakeClientsEvent());
    registerFallbackValue(FakeScheduleEvent());
    registerFallbackValue(FakeAnalyticsEvent());
    registerFallbackValue(FakeEmployeesEvent());
    registerFallbackValue(FakeGroupsEvent());
    registerFallbackValue(FakeEventAttendanceEvent());
  });

  setUp(() {
    mockClientsBloc = MockClientsBloc();
    mockScheduleBloc = MockScheduleBloc();
    mockAnalyticsBloc = MockAnalyticsBloc();
    mockEmployeesBloc = MockEmployeesBloc();
    mockGroupsBloc = MockGroupsBloc();
    mockEventAttendanceBloc = MockEventAttendanceBloc();

    // Задаем начальные состояния, чтобы виджеты не падали при отрисовке
    when(() => mockClientsBloc.state).thenReturn(ClientsLoading());
    when(() => mockScheduleBloc.state).thenReturn(ScheduleLoading());
    when(() => mockAnalyticsBloc.state).thenReturn(AnalyticsLoading());
    when(() => mockEmployeesBloc.state).thenReturn(EmployeesLoading());
    when(() => mockGroupsBloc.state).thenReturn(GroupsLoading());
    when(() => mockEventAttendanceBloc.state).thenReturn(EventAttendanceLoading());

    // НАСТРОЙКА GetIt: Регистрируем ВСЕ моки
    final sl = GetIt.instance;
    sl.reset();
    sl.registerFactory<ClientsBloc>(() => mockClientsBloc);
    sl.registerFactory<ScheduleBloc>(() => mockScheduleBloc);
    sl.registerFactory<AnalyticsBloc>(() => mockAnalyticsBloc);
    sl.registerFactory<EmployeesBloc>(() => mockEmployeesBloc);
    sl.registerFactory<GroupsBloc>(() => mockGroupsBloc);
    sl.registerFactory<EventAttendanceBloc>(() => mockEventAttendanceBloc);
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: DashboardScreen(),
    );
  }

  group('DashboardScreen Widget Tests', () {
    testWidgets('Отрисовывает DashboardDesktopView на широком экране (>800px)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(DashboardDesktopView), findsOneWidget);
      expect(find.byType(DashboardMobileView), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });

    testWidgets('Отрисовывает DashboardMobileView на узком экране (<800px)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(DashboardMobileView), findsOneWidget);
      expect(find.byType(DashboardDesktopView), findsNothing);

      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}