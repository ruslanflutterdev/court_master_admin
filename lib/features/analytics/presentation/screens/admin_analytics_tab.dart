import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/widgets/quick_sale_sheet.dart';
import '../bloc/analytics_bloc.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha(2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnalyticsBloc>()..add(LoadAnalyticsEvent()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Сводка',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => innerContext.read<AnalyticsBloc>().add(
                    LoadAnalyticsEvent(),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              heroTag: 'quick_sale_fab',
              onPressed: () async {
                // Берем общую базу клиентов из контекста
                final sharedClientsBloc = innerContext.read<ClientsBloc>();

                await showModalBottomSheet(
                  context: innerContext,
                  isScrollControlled: true,
                  builder: (ctx) => BlocProvider.value(
                    value: sharedClientsBloc, // Передаем ее в шторку!
                    child: const QuickSaleSheet(),
                  ),
                );

                // Когда шторка закрылась:
                if (!innerContext.mounted) return;
                innerContext.read<AnalyticsBloc>().add(LoadAnalyticsEvent());
              },
              backgroundColor: Colors.orange,
              icon: const Icon(Icons.flash_on, color: Colors.white),
              label: const Text(
                'Продажа',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
              builder: (context, state) {
                if (state is AnalyticsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AnalyticsError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is AnalyticsLoaded) {
                  final d = state.data;
                  return RefreshIndicator(
                    onRefresh: () async => innerContext
                        .read<AnalyticsBloc>()
                        .add(LoadAnalyticsEvent()),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        const Text(
                          'Финансы (Текущий месяц)',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildMetricCard(
                              'Выручка',
                              '${d.monthlyRevenue} ₸',
                              Icons.account_balance_wallet,
                              Colors.green,
                            ),
                            _buildMetricCard(
                              'Долги клиентов',
                              '${d.totalDebt} ₸',
                              Icons.money_off,
                              Colors.red,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Клиенты и Абонементы',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildMetricCard(
                              'Ученики',
                              '${d.clientsCount}',
                              Icons.people,
                              Colors.blue,
                            ),
                            _buildMetricCard(
                              'Акт. абонементы',
                              '${d.activeSubsCount}',
                              Icons.card_membership,
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }
}
