import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/clients_state.dart';
import '../cards/client_list_row.dart';

class ClientListView extends StatelessWidget {
  final List<ClientModel> clients;
  final ClientSegment currentSegment;
  final Function(String) onClientTap;

  const ClientListView({
    super.key,
    required this.clients,
    required this.currentSegment,
    required this.onClientTap,
  });

  @override
  Widget build(BuildContext context) {
    if (clients.isEmpty) {
      return const Center(child: Text('Клиенты не найдены'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: clients.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final client = clients[index];
        return ClientListRow(
          client: client,
          currentSegment: currentSegment,
          onTap: () => onClientTap(client.id),
        );
      },
    );
  }
}
