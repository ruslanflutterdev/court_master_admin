import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/create_schedule_event_sheet.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/forms/schedule_color_picker_row.dart'; // Импорт нового виджета

import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';

import 'package:court_master_admin/features/groups/presentation/bloc/groups_bloc.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_event.dart';
import 'package:court_master_admin/features/groups/presentation/bloc/groups_state.dart';

class MockScheduleBloc extends MockBloc<ScheduleEvent, ScheduleState>
    implements ScheduleBloc {}

class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState>
    implements ClientsBloc {}

class MockGroupsBloc extends MockBloc<GroupsEvent, GroupsState>
    implements GroupsBloc {}

// ❌ УБРАЛИ FakeScheduleEvent, так как ScheduleEvent теперь sealed class

void main() {
  late MockScheduleBloc mockScheduleBloc;
  late MockClientsBloc mockClientsBloc;
  late MockGroupsBloc mockGroupsBloc;

  setUpAll(() {
    // ✅ ИСПОЛЬЗУЕМ РЕАЛЬНОЕ СОБЫТИЕ
    registerFallbackValue(LoadScheduleData(DateTime.now()));
  });

  setUp(() {
    mockScheduleBloc = MockScheduleBloc();
    mockClientsBloc = MockClientsBloc();
    mockGroupsBloc = MockGroupsBloc();

    when(() => mockScheduleBloc.state).thenReturn(
      ScheduleLoaded(
        scheduleDate: DateTime.now(),
        scheduleEvents: const [],
        courts: const [],
        groups: const [],
        coaches: const [],
      ),
    );
    when(() => mockClientsBloc.state).thenReturn(ClientsLoaded(const []));
    when(() => mockGroupsBloc.state).thenReturn(GroupsLoaded(const []));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ScheduleBloc>.value(value: mockScheduleBloc),
            BlocProvider<ClientsBloc>.value(value: mockClientsBloc),
            BlocProvider<GroupsBloc>.value(value: mockGroupsBloc),
          ],
          child: CreateScheduleEventSheet(
            initialDate: DateTime.now(),
            startHour: 10,
            initialCourtId: 'c1',
            groups: const [],
          ),
        ),
      ),
    );
  }

  group('CreateScheduleEventSheet Widget Tests', () {
    testWidgets('Отображает форму создания нового события', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Проверяем, что на экране есть наша палитра цветов (то, что мы добавили недавно)
      expect(find.byType(ScheduleColorPickerRow), findsOneWidget);
      expect(find.text('Цвет: '), findsOneWidget);
    });

    testWidgets(
      'Блокирует отправку события при пустой форме (срабатывает валидация)',
          (tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        // Ищем кнопку сохранения (PrimaryButton содержит внутри ElevatedButton)
        final saveButton = find.byType(ElevatedButton).last;
        await tester.ensureVisible(saveButton);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Убеждаемся, что Bloc.add НЕ был вызван, так как форма пустая и не прошла валидацию
        verifyNever(
              () => mockScheduleBloc.add(
            any(that: isA<CreateScheduleEventRequested>()),
          ),
        );
      },
    );
  });
}