import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:court_master_admin/core/api/api_client.dart';
import 'package:court_master_admin/features/employees/presentation/screens/admin_coach_profile_screen.dart';
import 'package:court_master_admin/features/employees/data/models/coach_model.dart';

// Создаем моки для ApiClient и Dio
class MockApiClient extends Mock implements ApiClient {}

class MockDio extends Mock implements Dio {}

void main() {
  late MockApiClient mockApiClient;
  late MockDio mockDio;

  setUp(() {
    mockApiClient = MockApiClient();
    mockDio = MockDio();

    // Указываем, что когда кто-то просит dio у ApiClient, возвращать наш MockDio
    when(() => mockApiClient.dio).thenReturn(mockDio);

    // Регистрируем поддельный ApiClient в GetIt
    GetIt.I.registerSingleton<ApiClient>(mockApiClient);
  });

  tearDown(() {
    // Очищаем GetIt после теста
    GetIt.I.reset();
  });

  testWidgets(
    'Должен отображать данные тренера и загружать статистику с бекенда',
    (WidgetTester tester) async {
      // 1. Учим наш поддельный Dio отвечать на запрос статистики
      when(() => mockDio.get('/employees/1/stats')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/employees/1/stats'),
          statusCode: 200,
          data: {
            'groupsCount': 3,
            'eventsCount': 12,
            'salaryPending': 'TODO: Начисление ЗП',
          },
        ),
      );

      // 2. Тестовый тренер
      final coach = CoachModel(
        id: '1',
        firstName: 'Анна',
        lastName: 'Иванова',
        email: 'anna@test.com',
        role: 'tennisCoach',
        qualification: 'Мастер Спорта',
        specialization: 'Дети от 5 лет',
        rating: 5.0,
        salaryType: 'hourly',
        salaryRate: 5000,
      );

      // 3. Запускаем экран
      await tester.pumpWidget(
        MaterialApp(home: AdminCoachProfileScreen(coach: coach)),
      );

      // Проверяем, что статичные данные тренера загрузились сразу
      expect(find.text('Анна Иванова'), findsOneWidget);
      expect(find.text('Мастер Спорта'), findsOneWidget);
      expect(find.text('Дети от 5 лет'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);

      // 4. Ждем, пока отработает FutureBuilder (поддельный запрос к API)
      await tester.pumpAndSettle();

      // 5. Проверяем, что статистика из JSON успешно отрендерилась
      expect(find.text('Активные группы'), findsOneWidget);
      expect(find.text('3'), findsOneWidget); // groupsCount

      expect(find.text('Проведено занятий'), findsOneWidget);
      expect(find.text('12'), findsOneWidget); // eventsCount

      expect(find.text('Текущий заработок'), findsOneWidget);
      expect(find.text('TODO'), findsOneWidget); // Наша заглушка
      expect(
        find.text('Ставка: 5000 ₸/час'),
        findsOneWidget,
      ); // Ставка из модели
    },
  );
}
