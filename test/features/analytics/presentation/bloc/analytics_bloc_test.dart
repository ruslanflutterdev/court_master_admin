import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:court_master_admin/features/analytics/data/models/analytics_model.dart';
import 'package:court_master_admin/features/analytics/data/repositories/analytics_repository.dart';
import 'package:court_master_admin/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:court_master_admin/features/analytics/presentation/bloc/analytics_event.dart';
import 'package:court_master_admin/features/analytics/presentation/bloc/analytics_state.dart';

class MockAnalyticsRepo extends Mock implements AnalyticsRepository {}

void main() {
  group('AnalyticsBloc Tests', () {
    late AnalyticsBloc bloc;
    late MockAnalyticsRepo mockRepo;

    setUp(() {
      mockRepo = MockAnalyticsRepo();
      bloc = AnalyticsBloc(repository: mockRepo);
    });

    tearDown(() {
      bloc.close();
    });

    test('Начальное состояние — AnalyticsLoading', () {
      expect(bloc.state, isA<AnalyticsLoading>());
    });

    blocTest<AnalyticsBloc, AnalyticsState>(
      'Успешная загрузка данных: [AnalyticsLoading, AnalyticsLoaded]',
      build: () {
        // ИСПОЛЬЗУЕМ ПРАВИЛЬНОЕ НАЗВАНИЕ МЕТОДА: getDashboardData()
        when(() => mockRepo.getDashboardData()).thenAnswer(
          (_) async => AnalyticsModel(
            clientsCount: 150,
            totalDebt: 0,
            monthlyRevenue: 120000,
            activeSubsCount: 45,
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAnalyticsEvent()),
      expect: () => [isA<AnalyticsLoading>(), isA<AnalyticsLoaded>()],
    );

    blocTest<AnalyticsBloc, AnalyticsState>(
      'Ошибка загрузки: [AnalyticsLoading, AnalyticsError]',
      build: () {
        // ИСПОЛЬЗУЕМ ПРАВИЛЬНОЕ НАЗВАНИЕ МЕТОДА: getDashboardData()
        when(
          () => mockRepo.getDashboardData(),
        ).thenThrow(Exception('Server crash'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAnalyticsEvent()),
      expect: () => [isA<AnalyticsLoading>(), isA<AnalyticsError>()],
    );
  });
}
