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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.green.shade50,
                  child: Text(
                    client.firstName.isNotEmpty
                        ? client.firstName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${client.lastName} ${client.firstName}'.trim(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (client.companyName != null &&
                          client.companyName!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '🏢 ${client.companyName}',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        '📞 ${client.phone ?? "Нет телефона"}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        '✉️ ${client.email ?? "Нет email"}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Депозит',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '${client.balance} ₸',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: client.balance < 0 ? Colors.red : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Общая выручка',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '${client.totalSpent} ₸',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (client.tags.isNotEmpty ||
                client.skillLevel != null ||
                client.acquisitionSource != null) ...[
              const Divider(height: 24),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (client.skillLevel != null &&
                      client.skillLevel!.isNotEmpty)
                    Chip(
                      label: Text('🎾 Уровень: ${client.skillLevel}'),
                      backgroundColor: Colors.blue.shade50,
                      side: BorderSide.none,
                    ),
                  if (client.acquisitionSource != null &&
                      client.acquisitionSource!.isNotEmpty)
                    Chip(
                      label: Text('📢 Источник: ${client.acquisitionSource}'),
                      backgroundColor: Colors.purple.shade50,
                      side: BorderSide.none,
                    ),
                  ...client.tags.map((tag) => ClientTagChip(tag: tag)),
                ],
              ),
            ],
            if (client.notes != null && client.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.note_alt, size: 16, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Заметка:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client.notes!,
                      style: TextStyle(color: Colors.brown.shade800),
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
