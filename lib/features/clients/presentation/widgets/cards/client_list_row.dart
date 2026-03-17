import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';

class ClientListRow extends StatelessWidget {
  final ClientModel client;
  final VoidCallback onTap;

  const ClientListRow({super.key, required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final totalSpentText = client.balance > 0 ? '${client.balance} ₸' : '0 ₸';

    return InkWell(
      onTap: onTap,
      hoverColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade200)), // Только легкая линия снизу
        ),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text('${client.firstName} ${client.lastName}', style: const TextStyle(fontWeight: FontWeight.bold))),
            Expanded(flex: 2, child: Text(client.phone ?? '—', style: TextStyle(color: Colors.grey.shade700))),
            Expanded(flex: 2, child: Text(client.email ?? '—', style: TextStyle(color: Colors.grey.shade700))),
            Expanded(flex: 1, child: Text(totalSpentText, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))),
          ],
        ),
      ),
    );
  }
}

// Виджет для шапки таблицы
class ClientTableHeader extends StatelessWidget {
  const ClientTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Клиент', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text('Телефон', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 1, child: Text('Общая сумма', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
        ],
      ),
    );
  }
}