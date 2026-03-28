import 'package:flutter/material.dart';
import '../bloc/cashbox_bloc.dart';
import '../bloc/cashbox_event.dart';

class CashboxShiftReportDialog extends StatelessWidget {
  final Map<String, dynamic> result;
  final CashboxBloc bloc;

  const CashboxShiftReportDialog({
    super.key,
    required this.result,
    required this.bloc,
  });

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cash = result['totalCash'] ?? 0;
    final card = result['totalCard'] ?? 0;
    final total = (cash as num) + (card as num);

    return AlertDialog(
      title: const Text('Смена закрыта'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTotalRow('Итого наличные:', '$cash ₸'),
          _buildTotalRow('Итого безнал:', '$card ₸'),
          const Divider(),
          _buildTotalRow('ВСЕГО:', '${total.toInt()} ₸'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            bloc.add(LoadCashboxStatus());
          },
          child: const Text('ОК'),
        ),
      ],
    );
  }
}
