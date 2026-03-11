import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/widgets/sheets/quick_sale_sheet.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../widgets/metric_card.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

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
                final sharedClientsBloc = innerContext.read<ClientsBloc>();
                await showModalBottomSheet(
                  context: innerContext,
                  isScrollControlled: true,
                  builder: (ctx) => BlocProvider.value(
                    value: sharedClientsBloc,
                    child: const QuickSaleSheet(),
                  ),
                );
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
                            MetricCard(
                              title: 'Выручка',
                              value: '${d.monthlyRevenue} ₸',
                              icon: Icons.account_balance_wallet,
                              color: Colors.green,
                            ),
                            MetricCard(
                              title: 'Долги клиентов',
                              value: '${d.totalDebt} ₸',
                              icon: Icons.money_off,
                              color: Colors.red,
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
                            MetricCard(
                              title: 'Ученики',
                              value: '${d.clientsCount}',
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                            MetricCard(
                              title: 'Акт. абонементы',
                              value: '${d.activeSubsCount}',
                              icon: Icons.card_membership,
                              color: Colors.orange,
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
