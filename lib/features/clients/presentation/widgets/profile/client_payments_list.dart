import 'package:flutter/material.dart';
import '../../../data/models/payment_model.dart';

class ClientPaymentsList extends StatelessWidget {
  final List<PaymentModel> payments;

  const ClientPaymentsList({super.key, required this.payments});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Center(child: Text('История оплат пуста'));
    }

    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final pay = payments[index];
        final isIncome = pay.type == 1;
        final color = isIncome ? Colors.green : Colors.red;

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: color.withAlpha(51),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: color,
            ),
          ),
          title: Text(
            pay.description ??
                (isIncome ? 'Пополнение баланса' : 'Списание средств'),
          ),
          subtitle: Text(_formatDate(pay.createdAt)),
          trailing: Text(
            '${isIncome ? '+' : '-'}${pay.amount}',
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
}
