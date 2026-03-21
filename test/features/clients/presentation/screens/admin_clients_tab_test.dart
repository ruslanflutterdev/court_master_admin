import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';
import 'package:court_master_admin/features/clients/presentation/screens/admin_clients_tab.dart';
import 'package:court_master_admin/features/clients/presentation/widgets/search/client_search_header.dart';
import 'package:court_master_admin/features/clients/presentation/widgets/search/client_list_view.dart';
import 'package:court_master_admin/features/clients/data/models/client_model.dart';

class MockClientsBloc extends Mock implements ClientsBloc {}

void main() {
  late MockClientsBloc mockBloc;

  setUp(() {
    mockBloc = MockClientsBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  Widget buildWidget() {
    return MaterialApp(
      home: BlocProvider<ClientsBloc>.value(
        value: mockBloc,
        child: const AdminClientsTab(),
      ),
    );
  }

  group('AdminClientsTab Tests', () {
    testWidgets('Показывает список клиентов при успешной загрузке', (
      tester,
    ) async {
      // 🚀 ИСПРАВЛЕНО: Передаем список клиентов позиционно (без "clients:")
      when(() => mockBloc.state).thenReturn(
        ClientsLoaded(
          [
            ClientModel(
              id: '1',
              firstName: 'Иван',
              lastName: 'Иванов',
              phone: '123',
              balance: 0,
              activeSubscriptionsCount: 0,
              // 🚀 Убрали createdAt и добавили обязательные не-nullable поля:
              totalSpent: 0,
              hasRent: false,
              tags: const [],
            ),
          ],
          currentSegment: ClientSegment.all,
          sortBy: 'name',
        ),
      );

      await tester.pumpWidget(buildWidget());

      // Проверяем, что наши новые компоненты отрендерились
      expect(find.byType(ClientSearchHeader), findsOneWidget);
      expect(find.byType(ClientListView), findsOneWidget);
      expect(find.text('Иван Иванов'), findsOneWidget);
    });
  });
}
