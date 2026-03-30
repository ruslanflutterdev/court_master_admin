import 'package:flutter/material.dart';
import '../../bloc/cashbox/cashbox_bloc.dart';
import '../../bloc/cashbox/cashbox_event.dart';

class CashboxShiftReportDialog extends StatelessWidget {
  final Map<String, dynamic> result;
  final CashboxBloc bloc;

  const CashboxShiftReportDialog({
    super.key,
    required this.result,
    required this.bloc,
  });

  Widget _buildTotalRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Парсинг детальной статистики
    final rent = result['rent'] ?? result['courtRent'] ?? 0;
    final oneTime = result['oneTime'] ?? 0;
    final individual = result['individual'] ?? 0;
    final groupMembership = result['groupMembership'] ?? 0;
    final individualMembership = result['individualMembership'] ?? 0;
    final deposit = result['deposit'] ?? 0;

    final cash = result['totalCash'] ?? 0;
    final card = result['totalCard'] ?? 0;
    final total = (cash as num) + (card as num);

    return AlertDialog(
      title: const Text('Смена закрыта'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Детализация:',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            _buildTotalRow('Аренда корта:', '$rent ₸'),
            _buildTotalRow('Разовые занятия:', '$oneTime ₸'),
            _buildTotalRow('Индив. тренировки:', '$individual ₸'),
            _buildTotalRow('Членский взнос (группы):', '$groupMembership ₸'),
            _buildTotalRow(
              'Членский взнос (индив.):',
              '$individualMembership ₸',
            ),
            _buildTotalRow('Пополнение депозита:', '$deposit ₸'),
            const Divider(height: 24),
            _buildTotalRow('Итого наличные:', '$cash ₸', isBold: true),
            _buildTotalRow('Итого безнал:', '$card ₸', isBold: true),
            const Divider(height: 24, thickness: 2),
            _buildTotalRow('ВСЕГО:', '${total.toInt()} ₸', isBold: true),
          ],
        ),
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
