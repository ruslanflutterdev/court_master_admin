import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';
import 'package:court_master_admin/features/clients/presentation/widgets/sheets/quick_sale_sheet.dart';

// 1. Подделка для BLoC
class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState>
    implements ClientsBloc {}

class FakeClientsEvent extends Fake implements ClientsEvent {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeClientsEvent());
  });

  group('QuickSaleSheet Widget Tests', () {
    late MockClientsBloc mockBloc;

    setUp(() {
      mockBloc = MockClientsBloc();
      // Задаем начальное состояние, чтобы BLoC не ругался (пустой список клиентов)
      when(() => mockBloc.state).thenReturn(ClientsLoaded(const []));
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          // Оборачиваем наш Sheet в Scaffold
          body: BlocProvider<ClientsBloc>.value(
            value: mockBloc,
            child: const QuickSaleSheet(),
          ),
        ),
      );
    }

    testWidgets('Отрисовка формы Быстрой продажи и элементов управления', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // 1. Проверяем, что форма открылась и есть главный заголовок
      expect(find.text('Быстрая продажа'), findsOneWidget);

      // 2. Проверяем наличие секции "1. Клиент"
      expect(find.text('1. Клиент'), findsOneWidget);

      // 3. Проверяем наличие секции "2. Покупка"
      expect(find.text('2. Покупка'), findsOneWidget);

      // 4. Проверяем наличие кнопки продажи
      expect(find.text('Провести продажу'), findsOneWidget);
    });

    testWidgets('Показ ошибки, если нажать "Провести продажу" с пустыми полями', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Находим кнопку
      final buttonFinder = find.text('Провести продажу');

      // ЗАСТАВЛЯЕМ РОБОТА ПРОСКРОЛЛИТЬ ВНИЗ ДО КНОПКИ
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle(); // Ждем, пока закончится анимация скролла

      // Робот нажимает кнопку
      await tester.tap(buttonFinder);
      await tester
          .pumpAndSettle(); // Ждем анимацию появления красного текста ошибки

      // 🚀 ИСПРАВЛЕНО: Теперь мы ищем ошибку валидации формы без восклицательного знака!
      expect(find.text('Введите сумму'), findsOneWidget);
    });
  });
}
