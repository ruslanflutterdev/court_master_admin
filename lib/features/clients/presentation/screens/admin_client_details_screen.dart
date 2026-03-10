import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/client_details_bloc.dart';
import '../widgets/add_payment_sheet.dart';
import '../widgets/add_subscription_sheet.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminClientDetailsScreen extends StatelessWidget {
  final String clientId;

  const AdminClientDetailsScreen({super.key, required this.clientId});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ClientDetailsBloc>()..add(LoadClientDetails(clientId)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Профиль клиента'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Абонементы'),
                Tab(text: 'История оплат'),
              ],
            ),
          ),
          body: BlocBuilder<ClientDetailsBloc, ClientDetailsState>(
            builder: (context, state) {
              if (state is ClientDetailsLoading)
                return const Center(child: CircularProgressIndicator());
              if (state is ClientDetailsError)
                return Center(
                  child: Text(
                    'Ошибка: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );

              if (state is ClientDetailsLoaded) {
                final client = state.client;
                final subs = client.subscriptions ?? [];
                final payments = client.payments ?? [];

                return Column(
                  children: [
                    // Шапка с балансом
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${client.firstName} ${client.lastName}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                client.phone ?? client.email,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Баланс',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '${client.balance}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: client.balance >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Кнопки быстрых действий (Вызов шторок)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ClientDetailsBloc>(),
                                  child: AddSubscriptionSheet(
                                    clientId: clientId,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.card_membership),
                              label: const Text('Абонемент'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ClientDetailsBloc>(),
                                  child: AddPaymentSheet(clientId: clientId),
                                ),
                              ),
                              icon: const Icon(Icons.payment),
                              label: const Text('Платеж'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Вкладки
                    Expanded(
                      child: TabBarView(
                        children: [
                          // 1. Список абонементов
                          subs.isEmpty
                              ? const Center(
                                  child: Text('Нет купленных абонементов'),
                                )
                              : ListView.builder(
                                  itemCount: subs.length,
                                  itemBuilder: (context, index) {
                                    final sub = subs[index];
                                    final typeName = sub.type == 1
                                        ? 'Разовое'
                                        : (sub.type == 2
                                              ? 'Пакет'
                                              : 'Безлимит');

                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 6,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          typeName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'Использовано: ${sub.usedClasses} из ${sub.totalClasses}\nКуплен: ${_formatDate(sub.createdAt)}',
                                        ),
                                        trailing: Chip(
                                          label: Text(
                                            sub.status == 1
                                                ? 'Активен'
                                                : 'Завершен',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          backgroundColor: sub.status == 1
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                          // 2. История оплат
                          payments.isEmpty
                              ? const Center(child: Text('История оплат пуста'))
                              : ListView.builder(
                                  itemCount: payments.length,
                                  itemBuilder: (context, index) {
                                    final pay = payments[index];
                                    final isIncome =
                                        pay.type ==
                                        1; // 1 = Пополнение, 2 = Списание
                                    final color = isIncome
                                        ? Colors.green
                                        : Colors.red;

                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: color.withAlpha(2),
                                        child: Icon(
                                          isIncome
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          color: color,
                                        ),
                                      ),
                                      title: Text(
                                        pay.description ??
                                            (isIncome
                                                ? 'Пополнение баланса'
                                                : 'Списание средств'),
                                      ),
                                      subtitle: Text(
                                        _formatDate(pay.createdAt),
                                      ),
                                      trailing: Text(
                                        '${isIncome ? '+' : '-'}${pay.amount}',
                                        style: TextStyle(
                                          color: color,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
