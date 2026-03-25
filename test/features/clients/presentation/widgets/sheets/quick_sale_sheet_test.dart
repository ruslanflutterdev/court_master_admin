import 'package:court_master_admin/features/clients/presentation/widgets/sections/quick_sale_sheet.dart';
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

class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState>
    implements ClientsBloc {}

class FakeClientsEvent extends Fake implements ClientsEvent {}

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

      when(() => mockBloc.state).thenReturn(ClientsLoaded(const []));

      when(() => mockApiClient.dio).thenReturn(mockDio);
      when(() => mockDio.get('/employees/coaches')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/employees/coaches'),
          statusCode: 200,
          data: [],
        ),
      );
      GetIt.I.registerSingleton<ApiClient>(mockApiClient);
    });

    tearDown(() {
      GetIt.I.reset();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: Scaffold(
          body: BlocProvider<ClientsBloc>.value(
            value: mockBloc,
            child: const QuickSaleSheet(),
          ),
        ),
      );
    }

    testWidgets('Отрисовка формы Быстрой продажи и новых элементов B2B', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Проверяем главные заголовки (старых 1. Клиент и 2. Покупка больше нет)
      expect(find.text('Быстрая продажа'), findsOneWidget);
      expect(find.text('Клиент'), findsOneWidget);

      // Проверяем наличие новых фичей, которые мы добавили
      expect(find.text('Уровень игры'), findsOneWidget);
      expect(find.text('Юридическое лицо'), findsOneWidget);

      // Проверяем кнопку
      expect(find.text('Провести продажу'), findsOneWidget);
    });

    testWidgets(
      'Показ ошибки, если нажать "Провести продажу" с пустыми полями',
      (WidgetTester tester) async {
        await tester.pumpWidget(createWidgetUnderTest());
        await tester.pumpAndSettle();

        final buttonFinder = find.text('Провести продажу');
        await tester.ensureVisible(buttonFinder);
        await tester.pumpAndSettle();

        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        // Ищем ошибку валидации формы
        expect(find.text('Введите сумму'), findsOneWidget);
      },
    );
  });
}
