import 'package:flutter/material.dart';
import '../../../../clients/data/models/client_model.dart';
import 'client_tag_chip.dart';

class ClientInfoHeader extends StatelessWidget {
  final ClientModel client;

  const ClientInfoHeader({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green.shade100,
                  child: Text(
                    client.firstName.isNotEmpty
                        ? client.firstName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 24, color: Colors.green),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${client.lastName} ${client.firstName}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (client.companyName != null &&
                          client.companyName!.isNotEmpty)
                        Text(
                          '🏢 ${client.companyName}',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      const SizedBox(height: 4),
                      Text('📞 ${client.phone ?? "Нет телефона"}'),
                      Text('✉️ ${client.email ?? "Нет email"}'),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Баланс', style: TextStyle(color: Colors.grey)),
                    Text(
                      '${client.balance} ₸',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: client.balance < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (client.tags.isNotEmpty ||
                client.skillLevel != null ||
                client.acquisitionSource != null) ...[
              const Divider(height: 32),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (client.skillLevel != null &&
                      client.skillLevel!.isNotEmpty)
                    Chip(
                      label: Text('🎾 Уровень: ${client.skillLevel}'),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  if (client.acquisitionSource != null &&
                      client.acquisitionSource!.isNotEmpty)
                    Chip(
                      label: Text('📢 Пришел из: ${client.acquisitionSource}'),
                      backgroundColor: Colors.orange.shade50,
                    ),
                  ...client.tags.map((tag) => ClientTagChip(tag: tag)),
                ],
              ),
            ],
            if (client.notes != null && client.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.note_alt, size: 20, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Примечание / Отзыв:\n${client.notes}',
                        style: TextStyle(color: Colors.brown.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
