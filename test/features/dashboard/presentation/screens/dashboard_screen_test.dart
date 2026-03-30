import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:court_master_admin/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:court_master_admin/features/dashboard/presentation/widgets/dashboard_desktop_view.dart';
import 'package:court_master_admin/features/dashboard/presentation/widgets/dashboard_mobile_view.dart';

import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';
import 'package:court_master_admin/features/auth/data/models/user_model.dart';

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
import 'package:court_master_admin/features/cashbox/presentation/bloc/cashbox_bloc.dart';
import 'package:court_master_admin/features/cashbox/presentation/bloc/cashbox_event.dart';
import 'package:court_master_admin/features/cashbox/presentation/bloc/cashbox_state.dart';

// Подделки
class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState>
    implements ClientsBloc {}

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class MockAnalyticsBloc extends MockBloc<AnalyticsEvent, AnalyticsState>
    implements AnalyticsBloc {}

class MockEmployeesBloc extends MockBloc<EmployeesEvent, EmployeesState>
    implements EmployeesBloc {}

class MockGroupsBloc extends MockBloc<GroupsEvent, GroupsState>
    implements GroupsBloc {}

class MockCashboxBloc extends MockBloc<CashboxEvent, CashboxState>
    implements CashboxBloc {}

class FakeClientsEvent extends Fake implements ClientsEvent {}

// ❌ УБРАЛИ FakeScheduleEvent, так как ScheduleEvent теперь sealed class

class FakeAnalyticsEvent extends Fake implements AnalyticsEvent {}

class FakeEmployeesEvent extends Fake implements EmployeesEvent {}

class FakeGroupsEvent extends Fake implements GroupsEvent {}

class FakeCashboxEvent extends Fake implements CashboxEvent {}

void main() {
  late MockAuthBloc mockAuthBloc;
  late MockClientsBloc mockClientsBloc;
  late MockScheduleBloc mockScheduleBloc;
  late MockAnalyticsBloc mockAnalyticsBloc;
  late MockEmployeesBloc mockEmployeesBloc;
  late MockGroupsBloc mockGroupsBloc;
  late MockCashboxBloc mockCashboxBloc;

  setUpAll(() {
    // Используем реальный эвент вместо FakeAuthEvent
    registerFallbackValue(const CheckAuthEvent());

    registerFallbackValue(FakeClientsEvent());

    // ✅ ИСПОЛЬЗУЕМ РЕАЛЬНОЕ СОБЫТИЕ ВМЕСТО FAKE (Так как класс Sealed)
    registerFallbackValue(LoadScheduleData(DateTime.now()));

    registerFallbackValue(FakeAnalyticsEvent());
    registerFallbackValue(FakeEmployeesEvent());
    registerFallbackValue(FakeGroupsEvent());
    registerFallbackValue(FakeCashboxEvent());
  });

  setUp(() {
    mockAuthBloc = MockAuthBloc();
    mockClientsBloc = MockClientsBloc();
    mockScheduleBloc = MockScheduleBloc();
    mockAnalyticsBloc = MockAnalyticsBloc();
    mockEmployeesBloc = MockEmployeesBloc();
    mockGroupsBloc = MockGroupsBloc();
    mockCashboxBloc = MockCashboxBloc();

    final dummyUser = UserModel(
      id: '1',
      email: 'admin@test.com',
      firstName: 'Admin',
      lastName: '',
      role: 'SUPER_ADMIN',
    );

    when(
          () => mockAuthBloc.state,
    ).thenReturn(AuthAuthenticated(user: dummyUser));
    when(() => mockClientsBloc.state).thenReturn(ClientsLoading());
    when(() => mockScheduleBloc.state).thenReturn(ScheduleLoading());
    when(() => mockAnalyticsBloc.state).thenReturn(AnalyticsLoading());
    when(() => mockEmployeesBloc.state).thenReturn(EmployeesLoading());
    when(() => mockGroupsBloc.state).thenReturn(GroupsLoading());
    when(() => mockCashboxBloc.state).thenReturn(const CashboxLoading());

    final sl = GetIt.instance;
    sl.reset();
    sl.registerFactory<AuthBloc>(() => mockAuthBloc);
    sl.registerFactory<ClientsBloc>(() => mockClientsBloc);
    sl.registerFactory<ScheduleBloc>(() => mockScheduleBloc);
    sl.registerFactory<AnalyticsBloc>(() => mockAnalyticsBloc);
    sl.registerFactory<EmployeesBloc>(() => mockEmployeesBloc);
    sl.registerFactory<GroupsBloc>(() => mockGroupsBloc);
    sl.registerFactory<CashboxBloc>(() => mockCashboxBloc);
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: const DashboardScreen(),
      ),
    );
  }

  group('DashboardScreen Widget Tests', () {
    testWidgets(
      'Отрисовывает DashboardDesktopView на широком экране (>800px)',
          (tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pump();

        expect(find.byType(DashboardDesktopView), findsOneWidget);
        addTearDown(tester.view.resetPhysicalSize);
      },
    );

    testWidgets('Отрисовывает DashboardMobileView на узком экране (<800px)', (
        tester,
        ) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(DashboardMobileView), findsOneWidget);
      addTearDown(tester.view.resetPhysicalSize);
    });
  });
}