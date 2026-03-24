import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/schedule/data/models/schedule_event_model.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/cards/schedule_event_card.dart';

// Добавляем импорты AuthBloc
import 'package:court_master_admin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_event.dart';
import 'package:court_master_admin/features/auth/presentation/bloc/auth_state.dart';
import 'package:court_master_admin/features/auth/data/models/user_model.dart';

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  late MockAuthBloc mockAuthBloc;

  setUp(() {
    mockAuthBloc = MockAuthBloc();

    // Ставим роль ADMIN, чтобы работал Drag & Drop в тесте
    final dummyUser = UserModel(
      id: '1',
      email: 'admin@test.com',
      firstName: 'Admin',
      lastName: '',
      role: 'ADMIN',
    );
    when(
      () => mockAuthBloc.state,
    ).thenReturn(AuthAuthenticated(user: dummyUser));
  });

  Widget createWidgetUnderTest(ScheduleEventModel event, bool isPastDate) {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: mockAuthBloc,
        child: Scaffold(
          body: Stack(
            children: [
              ScheduleEventCard(
                event: event,
                isPastDate: isPastDate,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  final baseEvent = ScheduleEventModel(
    id: '1',
    eventType: 'rent',
    date: DateTime.now(),
    startTime: const TimeOfDay(hour: 10, minute: 0),
    endTime: const TimeOfDay(hour: 11, minute: 0),
    courtId: 'c1',
    clientName: 'Иван',
    colorHex: '#2196F3',
    price: 5000,
  );

  group('ScheduleEventCard Drag & Drop Tests', () {
    testWidgets('Будущее событие ДОЛЖНО иметь виджет LongPressDraggable', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(baseEvent, false));
      expect(
        find.byType(LongPressDraggable<ScheduleEventModel>),
        findsOneWidget,
      );
    });

    testWidgets('Прошедшее событие НЕ ДОЛЖНО иметь виджет LongPressDraggable', (
      tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest(baseEvent, true));
      expect(find.byType(LongPressDraggable<ScheduleEventModel>), findsNothing);
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
