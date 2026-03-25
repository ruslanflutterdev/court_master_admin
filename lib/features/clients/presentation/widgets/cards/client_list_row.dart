import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/clients_state.dart';

class ClientListRow extends StatelessWidget {
  final ClientModel client;
  final ClientSegment currentSegment;
  final VoidCallback onTap;

  const ClientListRow({
    super.key,
    required this.client,
    required this.currentSegment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String rightColumnText;
    Color rightColumnColor;

    final bool isDebtor = client.balance < 0;
    final bool hasUnpaid = client.tags.contains(
      'UNPAID_ATTENDANCE',
    ); // Предполагаем, что бэк может передавать это в тегах или отдельном поле

    if (currentSegment == ClientSegment.debtors || isDebtor) {
      rightColumnText = '${client.balance} ₸';
      rightColumnColor = Colors.red;
    } else if (currentSegment == ClientSegment.deposit) {
      rightColumnText = '${client.balance} ₸';
      rightColumnColor = Colors.blue;
    } else {
      rightColumnText = '${client.totalSpent} ₸';
      rightColumnColor = Colors.green;
    }

    return InkWell(
      onTap: onTap,
      hoverColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Text(
                    '${client.firstName} ${client.lastName}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (isDebtor || hasUnpaid)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red.shade700,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                client.phone ?? '—',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                client.email ?? '—',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                rightColumnText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: rightColumnColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClientTableHeader extends StatelessWidget {
  final ClientSegment currentSegment;

  const ClientTableHeader({super.key, required this.currentSegment});

  @override
  Widget build(BuildContext context) {
    String rightColumnTitle;

    if (currentSegment == ClientSegment.debtors) {
      rightColumnTitle = 'Долг';
    } else if (currentSegment == ClientSegment.deposit) {
      rightColumnTitle = 'Депозит';
    } else {
      rightColumnTitle = 'Общая сумма';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Клиент',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Телефон',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              rightColumnTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
