import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';
import 'client_stat_card_Item.dart';

class ClientStatsCards extends StatelessWidget {
  final ClientModel client;

  const ClientStatsCards({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClientStatCardItem(
          label: 'Баланс',
          value: '${client.balance} ₸',
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        ClientStatCardItem(
          label: 'Уровень',
          value: client.skillLevel ?? 'Н/Д',
          color: Colors.orange,
        ),
        const SizedBox(width: 12),
        ClientStatCardItem(
          label: 'Активных',
          value: '${client.activeSubscriptionsCount}',
          color: Colors.blue,
        ),
      ],
    );
  }
}
