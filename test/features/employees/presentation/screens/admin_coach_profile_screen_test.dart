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

    when(() => mockApiClient.dio).thenReturn(mockDio);
    GetIt.I.registerSingleton<ApiClient>(mockApiClient);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  testWidgets(
    'Должен отображать данные тренера, загружать статистику с бекенда и отображать 3 виджета расчета зарплаты',
    (WidgetTester tester) async {
      // 1. Учим наш поддельный Dio отвечать на запрос статистики
      when(() => mockDio.get('/employees/1/stats')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/employees/1/stats'),
          statusCode: 200,
          data: {
            'groupsCount': 3,
            'eventsCount': 12,
            'indivSalary': 4500,
            'groupSalary': 14000,
            'singleSalary': 2850,
          },
        ),
      );

      // 2. Тестовый тренер
      final coach = CoachModel(
        id: '1',
        firstName: 'Анна',
        lastName: 'Иванова',
        email: 'anna@test.com',
        role: 'COACH',
        qualification: 'Мастер Спорта',
        specialization: 'Дети от 5 лет',
        rating: 5.0,
        indivStateTaxRate: 10,
        indivClubTaxRate: 50,
        groupStateTaxRate: 0,
        groupClubTaxRate: 30,
        singleStateTaxRate: 5,
        singleClubTaxRate: 40,
      );

      // 3. Запускаем экран
      await tester.pumpWidget(
        MaterialApp(home: AdminCoachProfileScreen(coach: coach)),
      );

      // Ждем, пока отработает FutureBuilder (загрузится страница)
      await tester.pumpAndSettle();

      // 4. Проверяем, что статичные данные тренера успешно отрендерились
      expect(find.text('Анна Иванова'), findsOneWidget);
      expect(find.text('Дети от 5 лет'), findsOneWidget);

      // 5. Проверяем наличие наших 3 блоков зарплаты
      expect(find.text('Индивидуальные'), findsOneWidget);
      expect(find.text('Абонементы (Группы)'), findsOneWidget);
      expect(find.text('Разовые тренировки'), findsOneWidget);

      // 6. Проверяем, что заработанные суммы (из мока Dio) отобразились в UI
      expect(find.text('4500 ₸'), findsOneWidget);
      expect(find.text('14000 ₸'), findsOneWidget);
      expect(find.text('2850 ₸'), findsOneWidget);
    },
  );
}
