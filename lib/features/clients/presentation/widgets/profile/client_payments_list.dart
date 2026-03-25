import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/transaction_model.dart';
import '../../bloc/client_details_bloc.dart';
import '../../bloc/client_details_event.dart';
import '../../utils/payment_helper.dart';

class ClientPaymentsList extends StatelessWidget {
  final String clientId;
  final List<TransactionModel> transactions;

  const ClientPaymentsList({
    super.key,
    required this.clientId,
    required this.transactions,
  });

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
        final isIncome = tx.type == PaymentHelper.typeIncome;
        final isRefund = tx.type == PaymentHelper.typeRefund;

        final moneyColor = PaymentHelper.getTypeColor(tx.type);
        final sign = isIncome ? '+' : (isRefund ? '↺' : '-');

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: moneyColor.withAlpha(20),
            child: Icon(
              PaymentHelper.getMethodIcon(tx.paymentMethod),
              color: moneyColor,
            ),
          ),
          title: Text(
            tx.description ?? PaymentHelper.getTypeName(tx.type),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          subtitle: Text(
            '${_formatDate(tx.createdAt)} • ${PaymentHelper.getMethodName(tx.paymentMethod)}',
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$sign ${tx.amount} ₸',
                style: TextStyle(
                  color: moneyColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isIncome && tx.status != 'REFUNDED')
                IconButton(
                  icon: const Icon(
                    Icons.keyboard_return,
                    color: Colors.orange,
                    size: 20,
                  ),
                  onPressed: () => _showRefundDialog(context, tx),
                  tooltip: 'Сделать возврат',
                ),
            ],
          ),
        );
      },
    );
  }

  void _showRefundDialog(BuildContext context, TransactionModel tx) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Подтверждение возврата'),
        content: Text(
          'Вы уверены, что хотите сделать возврат по операции на сумму ${tx.amount} ₸?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<ClientDetailsBloc>().add(
                RefundTransactionEvent(
                  clientId: clientId,
                  transactionId: tx.id,
                ),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text(
              'Да, вернуть',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
