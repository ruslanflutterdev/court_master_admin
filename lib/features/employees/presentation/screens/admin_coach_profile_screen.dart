import 'package:flutter/material.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../data/models/coach_model.dart';

class AdminCoachProfileScreen extends StatelessWidget {
  final CoachModel coach;

  const AdminCoachProfileScreen({super.key, required this.coach});

  // Запрашиваем статистику напрямую через ApiClient
  Future<Map<String, dynamic>> _fetchStats() async {
    final response = await sl<ApiClient>().dio.get(
      '/employees/${coach.id}/stats',
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль тренера')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ШАПКА ПРОФИЛЯ (Аватар, Имя, Рейтинг)
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.sports_tennis,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${coach.firstName} ${coach.lastName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coach.qualification ?? 'Квалификация не указана',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 28),
                      const SizedBox(width: 8),
                      Text(
                        '${coach.rating}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 2. ИНФОРМАЦИЯ
            const Text(
              'Специализация',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              coach.specialization ?? 'Информация отсутствует',
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 40),

            const Text(
              'Статистика и Оплата',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 3. БЛОК СТАТИСТИКИ (Загружается с бекенда)
            FutureBuilder<Map<String, dynamic>>(
              future: _fetchStats(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(
                    'Ошибка загрузки: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  );
                }

                final stats = snapshot.data ?? {};
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Активные группы',
                            value: '${stats['groupsCount'] ?? 0}',
                            icon: Icons.group,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Проведено занятий',
                            value: '${stats['eventsCount'] ?? 0}',
                            icon: Icons.event_available,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ПЛАШКА ЗАРПЛАТЫ С ПОМЕТКОЙ TODO
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Текущий заработок',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'TODO',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stats['salaryPending'] ??
                                'Модуль начисления ЗП в разработке',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Ставка: ${coach.salaryRate ?? 0} ${coach.salaryType == 'percentage' ? '%' : '₸/час'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Вспомогательный виджет для карточек статистики
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
