import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/clients_bloc.dart';

class AdminClientsTab extends StatelessWidget {
  const AdminClientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Клиенты и Финансы'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Позже добавим поиск
            },
          ),
        ],
      ),
      body: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          if (state is ClientsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ClientsError) {
            return Center(
              child: Text(
                'Ошибка: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is ClientsLoaded) {
            if (state.clients.isEmpty) {
              return const Center(child: Text('Клиентов пока нет.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.clients.length,
              itemBuilder: (context, index) {
                final client = state.clients[index];

                // Логика цвета баланса
                Color balanceColor = Colors.grey;
                if (client.balance > 0) balanceColor = Colors.green;
                if (client.balance < 0) balanceColor = Colors.red;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        client.firstName[0],
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${client.firstName} ${client.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          client.phone ?? client.email,
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (client.activeSubscriptionsCount > 0)
                          Text(
                            'Активных абонементов: ${client.activeSubscriptionsCount}',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Баланс',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        Text(
                          '${client.balance} ₸', // Замени на нужную валюту, если требуется
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: balanceColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final bloc = context.read<ClientsBloc>();
                      await context.push('/client-details/${client.id}');
                      bloc.add(
                        LoadClientsEvent(),
                      ); // Обновляем список, когда вернемся!
                    },
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
