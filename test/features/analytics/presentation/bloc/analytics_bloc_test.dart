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
  late AnalyticsBloc bloc;
  late MockAnalyticsRepo mockRepo;

  // Данные для успешного теста вынесены в отдельную переменную (Rule: Clean code)
  final mockData = AnalyticsModel(
    clientsCount: 150,
    totalDebt: 0,
    monthlyRevenue: 120000,
    activeSubsCount: 45,
    revenueByCourt: [], // ИСПРАВЛЕНО: Добавлены требуемые поля
    revenueByCoach: [], // ИСПРАВЛЕНО: Добавлены требуемые поля
  );

  setUp(() {
    mockRepo = MockAnalyticsRepo();
    bloc = AnalyticsBloc(repository: mockRepo);
  });

  tearDown(() => bloc.close());

  group('AnalyticsBloc Tests', () {
    test('Начальное состояние — AnalyticsLoading', () {
      expect(bloc.state, isA<AnalyticsLoading>());
    });

    blocTest<AnalyticsBloc, AnalyticsState>(
      'Успешная загрузка данных',
      build: () {
        when(
          () => mockRepo.getDashboardData(),
        ).thenAnswer((_) async => mockData);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAnalyticsEvent()),
      expect: () => [isA<AnalyticsLoading>(), isA<AnalyticsLoaded>()],
    );

    blocTest<AnalyticsBloc, AnalyticsState>(
      'Ошибка загрузки',
      build: () {
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
