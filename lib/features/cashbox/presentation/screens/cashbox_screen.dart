import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../bloc/cashbox_bloc.dart';
import '../bloc/cashbox_event.dart';
import '../bloc/cashbox_state.dart';

class CashboxScreen extends StatefulWidget {
  const CashboxScreen({super.key});

  @override
  State<CashboxScreen> createState() => _CashboxScreenState();
}

class _CashboxScreenState extends State<CashboxScreen> {
  int _calculateTotal(Map<String, dynamic> data, String method) {
    if (data['transactions'] == null) return 0;
    final transactions = data['transactions'] as List;
    double total = 0;
    for (var tx in transactions) {
      final m = tx['type'] == 'income' ? 1 : -1;
      if (method == 'CASH' && tx['paymentMethod'] == 'CASH') {
        total += (tx['amount'] as num) * m;
      } else if (method == 'CARD' &&
          (tx['paymentMethod'] == 'CARD' ||
              tx['paymentMethod'] == 'QR' ||
              tx['paymentMethod'] == 'SBP')) {
        total += (tx['amount'] as num) * m;
      }
    }
    return total.toInt();
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

  void _showShiftReport(
    BuildContext context,
    Map<String, dynamic> result,
    CashboxBloc bloc,
  ) {
    final cash = result['totalCash'] ?? 0;
    final card = result['totalCard'] ?? 0;
    final total = (cash as num) + (card as num);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cashboxBloc = context.read<CashboxBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Сверка кассы')),
      body: BlocConsumer<CashboxBloc, CashboxState>(
        listener: (context, state) {
          if (state is CashboxError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is CashboxShiftClosed) {
            _showShiftReport(context, state.result, cashboxBloc);
          }
        },
        builder: (context, state) {
          if (state is CashboxLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CashboxLoaded) {
            final data = state.status;
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
                            '${_calculateTotal(data, 'CASH')} ₸',
                          ),
                          _buildTotalRow(
                            'Безналичные:',
                            '${_calculateTotal(data, 'CARD')} ₸',
                          ),
                        ],
                        const SizedBox(height: 32),
                        PrimaryButton(
                          text: isOpen ? 'Закрыть смену' : 'Открыть смену',
                          color: isOpen ? Colors.red : Colors.green,
                          onPressed: () {
                            if (isOpen) {
                              cashboxBloc.add(CloseShiftEvent());
                            } else {
                              cashboxBloc.add(OpenShiftEvent());
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

          return Center(
            child: PrimaryButton(
              text: 'Проверить статус',
              onPressed: () => cashboxBloc.add(LoadCashboxStatus()),
            ),
          );
        },
      ),
    );
  }
}
