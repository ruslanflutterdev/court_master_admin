import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/clients/data/models/client_model.dart';
import 'package:court_master_admin/features/clients/data/repositories/clients_repository.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/clients_state.dart';

class MockClientsRepository extends Mock implements ClientsRepository {}

void main() {
  group('ClientsBloc Tests', () {
    late ClientsBloc clientsBloc;
    late MockClientsRepository mockRepo;

    setUp(() {
      mockRepo = MockClientsRepository();
      clientsBloc = ClientsBloc(repository: mockRepo);
    });

    tearDown(() {
      clientsBloc.close();
    });

    test('Начальное состояние — ClientsLoading', () {
      expect(clientsBloc.state, isA<ClientsLoading>());
    });

    blocTest<ClientsBloc, ClientsState>(
      'Успешная загрузка списка клиентов: [ClientsLoading, ClientsLoaded]',
      build: () {
        when(() => mockRepo.getClients()).thenAnswer(
              (_) async => [
            ClientModel(
              id: '1',
              firstName: 'Иван',
              lastName: 'Иванов',
              email: 'test@test.com',
              balance: 0,
              activeSubscriptionsCount: 0,
            )
          ],
        );
        return clientsBloc;
      },
      act: (bloc) => bloc.add(LoadClientsEvent()),
      expect: () => [
        isA<ClientsLoading>(),
        isA<ClientsLoaded>(),
      ],
    );

    blocTest<ClientsBloc, ClientsState>(
      'Сценарий Быстрой продажи: вызывает перезагрузку списка клиентов',
      build: () {
        final saleData = {'amount': 500};
        when(() => mockRepo.quickSale(saleData)).thenAnswer((_) async {});
        when(() => mockRepo.getClients()).thenAnswer((_) async => []); // Для перезагрузки
        return clientsBloc;
      },
      act: (bloc) => bloc.add(QuickSaleRequested({'amount': 500})),
      expect: () => [
        isA<ClientsLoading>(), // Вызывается внутри LoadClientsEvent после успешной продажи
        isA<ClientsLoaded>(),
      ],
    );
  });
}