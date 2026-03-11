import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/clients_bloc.dart';
import '../bloc/clients_event.dart';
import '../bloc/clients_state.dart';
import '../widgets/cards/client_list_card.dart';

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
              // Позже вынесем поиск в отдельный виджет
            },
          ),
        ],
      ),
      body: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          if (state is ClientsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClientsError) {
            return Center(
              child: Text(
                'Ошибка: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (state is ClientsLoaded) {
            if (state.clients.isEmpty) {
              return const Center(child: Text('Клиентов пока нет.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.clients.length,
              itemBuilder: (context, index) {
                final client = state.clients[index];
                return ClientListCard(
                  client: client,
                  onTap: () async {
                    final bloc = context.read<ClientsBloc>();
                    await context.push('/client-details/${client.id}');
                    bloc.add(LoadClientsEvent());
                  },
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
