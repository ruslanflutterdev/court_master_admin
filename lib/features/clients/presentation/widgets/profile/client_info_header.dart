import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';
import 'client_tag_chip.dart';

class ClientInfoHeader extends StatelessWidget {
  final ClientModel client;

  const ClientInfoHeader({super.key, required this.client});

  Widget _buildB2BBadge() {
    if (!client.isCorporate) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        'B2B Клиент',
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildCompanyInfo() {
    if (!client.isCorporate) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        '${client.companyName ?? ''} (ИНН: ${client.inn ?? '-'}, КПП: ${client.kpp ?? '-'})',
        style: const TextStyle(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  Widget _buildTags() {
    final tags = <String>[];
    if (client.skillLevel != null) tags.add('Уровень: ${client.skillLevel}');
    if (client.acquisitionSource != null) {
      tags.add('Источник: ${client.acquisitionSource}');
    }
    tags.addAll(client.tags);

    if (tags.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: tags.map((t) => ClientTagChip(tag: t)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${client.firstName} ${client.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildB2BBadge(),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          client.phone ?? 'Нет телефона',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        _buildCompanyInfo(),
        _buildTags(),
      ],
    );
  }
}
