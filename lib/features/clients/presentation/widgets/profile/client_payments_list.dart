import 'package:flutter/material.dart';
import '../../../data/models/payment_model.dart';
import '../../utils/payment_helper.dart';

class ClientPaymentsList extends StatelessWidget {
  final List<PaymentModel> payments;

  const ClientPaymentsList({super.key, required this.payments});

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return const Text(
        'У клиента пока нет транзакций',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      children: payments.map((payment) {
        final color = PaymentHelper.getTypeColor(payment.type);
        final sign = payment.type == 1 ? '+' : (payment.type == 2 ? '-' : '');
        final date = payment.createdAt;

        final dateStr =
            '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
        final timeStr =
            '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: Colors.grey.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withAlpha(20),
              child: Icon(
                PaymentHelper.getMethodIcon(payment.method),
                color: color,
              ),
            ),
            title: Text(
              PaymentHelper.getTypeName(payment.type),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${PaymentHelper.getMethodName(payment.method)} • $dateStr $timeStr',
                  style: const TextStyle(fontSize: 12),
                ),
                if (payment.description != null &&
                    payment.description!.isNotEmpty)
                  Text(
                    payment.description!,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
              ],
            ),
            trailing: Text(
              '$sign${payment.amount} ₸',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
