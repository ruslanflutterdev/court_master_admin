import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_event.dart'; // 🚀 ДОБАВЛЕН ИМПОРТ
import 'package:court_master_admin/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/create_schedule_event_sheet.dart';

class MockScheduleBloc extends Mock implements ScheduleBloc {}

class FakeScheduleEvent extends Fake
    implements ScheduleEvent {} // 🚀 ДОБАВЛЕН ФЕЙК

void main() {
  // 🚀 ДОБАВЛЕНА РЕГИСТРАЦИЯ ФЕЙКА
  setUpAll(() {
    registerFallbackValue(FakeScheduleEvent());
  });

  late MockScheduleBloc mockBloc;

  setUp(() {
    mockBloc = MockScheduleBloc();
    when(() => mockBloc.state).thenReturn(
      ScheduleLoaded(
        scheduleDate: DateTime(2025, 3, 20),
        courts: const [],
        scheduleEvents: const [],
        groups: const [],
        coaches: const [],
      ),
    );
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildTestWidget() {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider<ScheduleBloc>.value(
          value: mockBloc,
          child: CreateScheduleEventSheet(
            initialDate: DateTime(2025, 3, 20), // 🚀 Новое имя параметра
            startHour: 14,
            initialCourtId: 'court-1', // 🚀 Новое имя параметра
            groups: const [],
          ),
        ),
      ),
    );
  }

  group('CreateScheduleEventSheet Widget Tests', () {
    testWidgets('Отображает форму создания нового события', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());

      // 1. Проверяем наличие заголовка
      expect(find.text('Новое событие'), findsOneWidget);

      // 2. Проверяем наличие выбора типа события (наш вынесенный EventTypeSelector)
      expect(find.text('Тип события'), findsOneWidget);

      // 3. Проверяем наличие кнопки Создать (наш PrimaryButton)
      expect(find.text('Создать'), findsOneWidget);
    });

    testWidgets(
      'Отправляет событие CreateScheduleEventRequested при сохранении',
      (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        // Скроллим до кнопки и нажимаем на неё
        await tester.ensureVisible(find.text('Создать'));
        await tester.tap(find.text('Создать'));
        await tester.pumpAndSettle();

        // Так как форма по умолчанию уже содержит валидные данные (текущее время, тип),
        // мы ожидаем, что событие создания БУДЕТ отправлено 1 раз.
        verify(
          () => mockBloc.add(any(that: isA<CreateScheduleEventRequested>())),
        ).called(1);
      },
    );
  });
}
