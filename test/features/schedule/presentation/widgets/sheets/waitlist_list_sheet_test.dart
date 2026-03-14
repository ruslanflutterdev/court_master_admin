import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist_bloc.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist_event.dart';
import 'package:court_master_admin/features/schedule/presentation/bloc/waitlist_state.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/waitlist_list_sheet.dart';
import 'package:court_master_admin/features/schedule/data/models/waitlist_model.dart';

// Создаем "фейковый" BLoC для подмены реального
class MockWaitlistBloc extends MockBloc<WaitlistEvent, WaitlistState>
    implements WaitlistBloc {}

// Заглушка события для mocktail
class FakeWaitlistEvent extends Fake implements WaitlistEvent {}

void main() {
  group('WaitlistListSheet Widget Tests', () {
    late MockWaitlistBloc mockBloc;
    final testDate = DateTime(2026, 3, 14);

    setUpAll(() {
      registerFallbackValue(FakeWaitlistEvent());
    });

    setUp(() {
      mockBloc = MockWaitlistBloc();
    });

    // Вспомогательная функция для оборачивания виджета
    Widget buildWidget() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<WaitlistBloc>.value(
            value: mockBloc,
            child: WaitlistListSheet(date: testDate),
          ),
        ),
      );
    }

    testWidgets(
      'Показывает CircularProgressIndicator при состоянии WaitlistLoading',
      (tester) async {
        when(() => mockBloc.state).thenReturn(WaitlistLoading());

        await tester.pumpWidget(buildWidget());

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('Показывает сообщение "Пока никого нет", если список пуст', (
      tester,
    ) async {
      when(
        () => mockBloc.state,
      ).thenReturn(WaitlistLoaded(waitlist: [], date: testDate));

      await tester.pumpWidget(buildWidget());

      expect(find.text('Пока никого нет'), findsOneWidget);
    });

    testWidgets('Отображает список клиентов и кнопку удаления', (tester) async {
      final mockWaitlist = [
        WaitlistModel(
          id: 'w1',
          date: testDate,
          startTime: '18:00',
          endTime: '19:00',
          clientName: 'Иван Иванов',
          clientPhone: '+79990001122',
          status: 'pending',
        ),
      ];
      when(
        () => mockBloc.state,
      ).thenReturn(WaitlistLoaded(waitlist: mockWaitlist, date: testDate));

      await tester.pumpWidget(buildWidget());

      // Проверяем, что данные отрисовались
      expect(find.text('Иван Иванов'), findsOneWidget);
      expect(find.text('18:00 - 19:00 | +79990001122'), findsOneWidget);

      // Нажимаем на кнопку корзины (удаление)
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Проверяем, что в BLoC улетело событие RemoveFromWaitlist
      verify(
        () => mockBloc.add(any(that: isA<RemoveFromWaitlist>())),
      ).called(1);
    });
  });
}
