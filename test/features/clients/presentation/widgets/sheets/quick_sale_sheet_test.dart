import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import 'package:court_master_admin/core/api/api_client.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';
import 'package:court_master_admin/features/clients/presentation/widgets/sheets/quick_sale_sheet.dart';

// 1. Подделка для BLoC
class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState>
    implements ClientsBloc {}

class FakeClientsEvent extends Fake implements ClientsEvent {}

// 🚀 ДОБАВЛЯЕМ МОКИ ДЛЯ СЕТИ
class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUpAll(() {
    registerFallbackValue(FakeClientsEvent());
  });

  group('QuickSaleSheet Widget Tests', () {
    late MockClientsBloc mockBloc;

    setUp(() {
      mockBloc = MockClientsBloc();
      mockApiClient = MockApiClient();
      mockDio = MockDio();

      // Задаем начальное состояние, чтобы BLoC не ругался (пустой список клиентов)
      when(() => mockBloc.state).thenReturn(ClientsLoaded(const []));

      // 🚀 РЕГИСТРИРУЕМ ПОДДЕЛЬНЫЙ API CLIENT
      when(() => mockApiClient.dio).thenReturn(mockDio);
      when(() => mockDio.get('/employees/coaches')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/employees/coaches'),
          statusCode: 200,
          data: [], // Отдаем пустой список тренеров для теста
        ),
      );
      GetIt.I.registerSingleton<ApiClient>(mockApiClient);
    });

    tearDown(() {
      GetIt.I.reset(); // Очищаем GetIt после каждого теста
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
      await tester.pumpAndSettle(); // Ждем окончания загрузки тренеров

      // 1. Проверяем, что форма открылась и есть главный заголовок
      expect(find.text('Быстрая продажа'), findsOneWidget);

      // 2. Проверяем наличие секции "1. Клиент"
      expect(find.text('1. Клиент'), findsOneWidget);

      // 3. Проверяем наличие секции "2. Покупка"
      expect(find.text('2. Покупка'), findsOneWidget);

      // 4. Проверяем наличие кнопки продажи
      expect(find.text('Провести продажу'), findsOneWidget);
    });

    testWidgets(
      'Показ ошибки, если нажать "Провести продажу" с пустыми полями',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle(); // Ждем окончания загрузки тренеров

        // Находим кнопку
        final buttonFinder = find.text('Провести продажу');

        // ЗАСТАВЛЯЕМ РОБОТА ПРОСКРОЛЛИТЬ ВНИЗ ДО КНОПКИ
        await tester.ensureVisible(buttonFinder);
        await tester.pumpAndSettle(); // Ждем, пока закончится анимация скролла

        // Робот нажимает кнопку
        await tester.tap(buttonFinder);
        await tester
            .pumpAndSettle(); // Ждем анимацию появления красного текста ошибки

        // Ищем ошибку валидации формы
        expect(find.text('Введите сумму'), findsOneWidget);
      },
    );
  });
}
