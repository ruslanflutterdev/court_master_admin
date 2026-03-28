import 'package:flutter/material.dart';
import '../../bloc/clients_state.dart';

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
