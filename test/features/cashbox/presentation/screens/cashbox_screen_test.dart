import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/cashbox/presentation/screens/cashbox_screen.dart';
import 'package:court_master_admin/features/cashbox/presentation/bloc/cashbox_bloc.dart';
import 'package:court_master_admin/features/cashbox/presentation/bloc/cashbox_state.dart';
import 'package:court_master_admin/features/cashbox/presentation/bloc/cashbox_event.dart';
import 'package:bloc_test/bloc_test.dart';

class MockCashboxBloc extends MockBloc<CashboxEvent, CashboxState>
    implements CashboxBloc {}

class FakeCashboxEvent extends Fake implements CashboxEvent {}

void main() {
  late MockCashboxBloc mockCashboxBloc;

  setUpAll(() {
    registerFallbackValue(FakeCashboxEvent());
  });

  setUp(() {
    mockCashboxBloc = MockCashboxBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<CashboxBloc>.value(
        value: mockCashboxBloc,
        child: const CashboxScreen(),
      ),
    );
  }

  testWidgets('Отображает состояние "Смена закрыта", если isOpen: false', (
    tester,
  ) async {
    when(
      () => mockCashboxBloc.state,
    ).thenReturn(CashboxLoaded(const {'isOpen': false, 'status': 'CLOSED'}));

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Смена закрыта'), findsOneWidget);
    expect(find.text('Открыть смену'), findsOneWidget);
  });

  testWidgets(
    'Отображает состояние "Смена открыта" и суммы, если status: OPEN',
    (tester) async {
      when(() => mockCashboxBloc.state).thenReturn(
        CashboxLoaded(const {
          'status': 'OPEN',
          'transactions': [
            {'amount': 1000, 'type': 'income', 'paymentMethod': 'CASH'},
            {'amount': 2000, 'type': 'income', 'paymentMethod': 'CARD'},
          ],
        }),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Смена открыта'), findsOneWidget);
      expect(find.text('Наличные:'), findsOneWidget);
      expect(find.text('1000 ₸'), findsOneWidget);
      expect(find.text('Безналичные:'), findsOneWidget);
      expect(find.text('2000 ₸'), findsOneWidget);
      expect(find.text('Закрыть смену'), findsOneWidget);
    },
  );

  testWidgets('Вызывает CloseShiftEvent при нажатии кнопки "Закрыть смену"', (
    tester,
  ) async {
    when(
      () => mockCashboxBloc.state,
    ).thenReturn(CashboxLoaded(const {'status': 'OPEN', 'transactions': []}));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.text('Закрыть смену'));

    verify(
      () => mockCashboxBloc.add(any(that: isA<CloseShiftEvent>())),
    ).called(1);
  });
}
