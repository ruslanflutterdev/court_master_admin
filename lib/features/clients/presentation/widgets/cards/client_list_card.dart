import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';

class ClientListCard extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onTap;

  const ClientListCard({super.key, required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
            client.firstName.isNotEmpty ? client.firstName[0] : '?',
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
                style: const TextStyle(color: Colors.orange, fontSize: 12),
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
              '${client.balance} ₸',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: balanceColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
