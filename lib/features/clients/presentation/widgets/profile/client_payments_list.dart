import 'package:flutter/material.dart';
import '../../../../clients/data/models/transaction_model.dart';

class ClientPaymentsList extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ClientPaymentsList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'История операций пуста',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isIncome = tx.type == 'income';

        Color catColor = Colors.grey;
        IconData catIcon = Icons.monetization_on;
        String catName = tx.description ?? 'Операция';

        if (tx.category == 'rent') {
          catColor = Colors.orange;
          catIcon = Icons.sports_tennis;
        } else if (tx.category == 'group_sub' || tx.category == 'indiv_sub') {
          catColor = Colors.purple;
          catIcon = Icons.card_membership;
        } else if (tx.category == 'deposit') {
          catColor = Colors.blue;
          catIcon = Icons.account_balance_wallet;
        }


        final moneyColor = isIncome ? Colors.green : Colors.red;
        final sign = isIncome ? '+' : '-';

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: catColor.withAlpha(20),
            child: Icon(catIcon, color: catColor),
          ),
          title: Text(
            catName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            _formatDate(tx.createdAt),
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Text(
            '$sign ${tx.amount} ₸',
            style: TextStyle(
              color: moneyColor,
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
