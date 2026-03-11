import 'package:flutter/material.dart';
import '../../../data/models/subscription_model.dart';

class ClientSubscriptionsList extends StatelessWidget {
  final List<SubscriptionModel> subscriptions;

  const ClientSubscriptionsList({super.key, required this.subscriptions});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const Center(child: Text('Нет купленных абонементов'));
    }

    return ListView.builder(
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final sub = subscriptions[index];
        final typeName = sub.type == 1
            ? 'Разовое'
            : (sub.type == 2 ? 'Пакет' : 'Безлимит');

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            title: Text(
              typeName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Использовано: ${sub.usedClasses} из ${sub.totalClasses}\nКуплен: ${_formatDate(sub.createdAt)}',
            ),
            trailing: Chip(
              label: Text(
                sub.status == 1 ? 'Активен' : 'Завершен',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              backgroundColor: sub.status == 1 ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
