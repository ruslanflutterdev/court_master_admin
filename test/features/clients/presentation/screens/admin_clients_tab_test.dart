import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';
import 'package:court_master_admin/features/clients/presentation/screens/admin_clients_tab.dart';
import 'package:court_master_admin/features/clients/data/models/client_model.dart';
import 'package:court_master_admin/features/clients/presentation/widgets/cards/client_list_row.dart';

class MockClientsBloc extends MockBloc<ClientsEvent, ClientsState> implements ClientsBloc {}

void main() {
  late MockClientsBloc mockBloc;

  setUp(() {
    mockBloc = MockClientsBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<ClientsBloc>.value(
        value: mockBloc,
        child: const AdminClientsTab(),
      ),
    );
  }

  group('AdminClientsTab Tests', () {
    testWidgets('Показывает список клиентов в виде таблицы (ClientListRow)', (tester) async {
      // Подготовим фейкового клиента с новыми полями
      final fakeClient = ClientModel(
        id: '1',
        firstName: 'Иван',
        lastName: 'Иванов',
        phone: '123',
        balance: 1000,
        totalSpent: 5000, // Наша новая выручка
        hasRent: true,    // Наш новый флаг аренды
      );

      when(() => mockBloc.state).thenReturn(
        ClientsLoaded([fakeClient], filteredClients: [fakeClient]),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      // 1. Проверяем наличие строки поиска
      expect(find.byType(TextField), findsOneWidget);

      // 2. Проверяем, что отображается таблица с заголовками
      expect(find.text('Клиент'), findsOneWidget);
      expect(find.text('Общая сумма'), findsOneWidget);

      // 3. Проверяем, что наша строка (ClientListRow) отрисовалась с правильными данными
      expect(find.byType(ClientListRow), findsOneWidget);
      expect(find.text('Иван Иванов'), findsOneWidget);
      expect(find.text('5000 ₸'), findsOneWidget); // Проверяем, что вывелся totalSpent
    });

    testWidgets('Проверка выпадающих списков фильтров (Шторки)', (tester) async {
      when(() => mockBloc.state).thenReturn(ClientsLoaded(const []));

      await tester.pumpWidget(createWidgetUnderTest());

      // У нас должно быть три выпадающих списка: Уровень, Статус, Сортировка
      expect(find.text('Все'), findsWidgets); // Значение по умолчанию для Уровня и Статуса
      expect(find.text('По алфавиту'), findsOneWidget); // Значение по умолчанию для Сортировки

      // Нажимаем на сортировку (По алфавиту)
      await tester.tap(find.text('По алфавиту'));
      await tester.pumpAndSettle();

      // Проверяем, что в списке появились новые умные сортировки
      expect(find.text('Сначала должники').last, findsOneWidget);
      expect(find.text('По выручке').last, findsOneWidget);
    });

    testWidgets('Пагинация: Проверка изменения количества элементов на странице', (tester) async {
      when(() => mockBloc.state).thenReturn(ClientsLoaded(const []));

      await tester.pumpWidget(createWidgetUnderTest());

      // Проверяем наличие футера пагинации
      expect(find.text('Показывать:'), findsOneWidget);

      // По умолчанию 20 элементов
      expect(find.text('20'), findsOneWidget);

      // Открываем список количества элементов
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();

      // Проверяем, что можно выбрать 50 или 100
      expect(find.text('50').last, findsOneWidget);
      expect(find.text('100').last, findsOneWidget);
    });
  });
}