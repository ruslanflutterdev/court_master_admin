import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/clients/data/models/client_model.dart';
import 'package:court_master_admin/features/clients/data/repositories/clients_repository.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/client_details_bloc.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/client_details_event.dart';
import 'package:court_master_admin/features/clients/presentation/bloc/client_details_state.dart';

class MockClientsRepository extends Mock implements ClientsRepository {}

void main() {
  group('ClientDetailsBloc Tests', () {
    late ClientDetailsBloc bloc;
    late MockClientsRepository mockRepo;

    final testClient = ClientModel(
      id: '1',
      firstName: 'Иван',
      lastName: 'Иванов',
      email: 'ivan@test.com',
      balance: 1000,
      activeSubscriptionsCount: 1,
    );

    setUp(() {
      mockRepo = MockClientsRepository();
      bloc = ClientDetailsBloc(repository: mockRepo);
    });

    tearDown(() {
      bloc.close();
    });

    test('Начальное состояние — ClientDetailsLoading', () {
      expect(bloc.state, isA<ClientDetailsLoading>());
    });

    blocTest<ClientDetailsBloc, ClientDetailsState>(
      'Загрузка деталей клиента: [ClientDetailsLoading, ClientDetailsLoaded]',
      build: () {
        when(
          () => mockRepo.getClientDetails('1'),
        ).thenAnswer((_) async => testClient);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadClientDetails(clientId: '1')),
      expect: () => [isA<ClientDetailsLoading>(), isA<ClientDetailsLoaded>()],
    );

    blocTest<ClientDetailsBloc, ClientDetailsState>(
      'Добавление платежа: автоматически перезапрашивает профиль клиента',
      build: () {
        when(
          () => mockRepo.addPayment('1', {'amount': 1000}),
        ).thenAnswer((_) async {});
        when(
          () => mockRepo.getClientDetails('1'),
        ).thenAnswer((_) async => testClient);
        return bloc;
      },
      act: (bloc) => bloc.add(AddPaymentEvent('1', {'amount': 1000})),
      expect: () => [
        isA<
          ClientDetailsLoading
        >(), // Вызывается внутри LoadClientDetails, добавленного после платежа
        isA<ClientDetailsLoaded>(),
      ],
    );
  });
}
