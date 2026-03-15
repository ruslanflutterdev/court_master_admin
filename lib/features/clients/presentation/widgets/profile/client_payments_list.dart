import 'package:flutter/material.dart';
import '../../../../clients/data/models/transaction_model.dart';

class ClientPaymentsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ClientPaymentsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'История операций пуста',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        // Если это Приход ('income') - цвет зеленый и плюсик, если расход - красный и минус
        final isIncome = tx.type == 'income';
        final color = isIncome ? Colors.green : Colors.red;
        final sign = isIncome ? '+' : '-';

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withAlpha(20),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
            ),
          ),
          title: Text(
            tx.description ?? 'Финансовая операция',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_formatDate(tx.createdAt)),
          trailing: Text(
            '$sign ${tx.amount} ₸',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
