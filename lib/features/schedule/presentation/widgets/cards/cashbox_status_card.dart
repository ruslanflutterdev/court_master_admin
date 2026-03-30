import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/primary_button.dart';
import '../../bloc/cashbox/cashbox_bloc.dart';
import '../../bloc/cashbox/cashbox_event.dart';
import '../../utils/cashbox_helper.dart';

class CashboxStatusCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final CashboxBloc bloc;

  const CashboxStatusCard({super.key, required this.data, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final bool isOpen = data['status'] == 'OPEN';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isOpen ? Icons.lock_open : Icons.lock_outline,
                  size: 64,
                  color: isOpen ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  isOpen ? 'Смена открыта' : 'Смена закрыта',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isOpen) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Смена ID: ${data['id']?.toString().substring(0, 8) ?? '-'}',
                  ),
                  const Divider(height: 32),
                  _buildTotalRow(
                    'Наличные:',
                    '${CashboxHelper.calculateTotal(data, 'CASH')} ₸',
                  ),
                  _buildTotalRow(
                    'Безналичные:',
                    '${CashboxHelper.calculateTotal(data, 'CARD')} ₸',
                  ),
                ],
                const SizedBox(height: 32),
                PrimaryButton(
                  text: isOpen ? 'Закрыть смену' : 'Открыть смену',
                  color: isOpen ? Colors.red : Colors.green,
                  onPressed: () {
                    if (isOpen) {
                      bloc.add(CloseShiftEvent());
                    } else {
                      bloc.add(OpenShiftEvent());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
}
