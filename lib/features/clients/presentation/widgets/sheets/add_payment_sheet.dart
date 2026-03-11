import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/client_details_bloc.dart';
import '../../bloc/client_details_event.dart';

class AddPaymentSheet extends StatefulWidget {
  final String clientId;
  const AddPaymentSheet({super.key, required this.clientId});

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  int _selectedType = 1; // 1 - Пополнение, 2 - Списание
  int _selectedMethod = 1; // 1 - Наличные, 2 - Карта, 3 - Перевод

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Провести платеж',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 1, label: Text('Пополнение')),
              ButtonSegment(value: 2, label: Text('Списание')),
            ],
            selected: {_selectedType},
            onSelectionChanged: (set) =>
                setState(() => _selectedType = set.first),
            style: SegmentedButton.styleFrom(
              selectedBackgroundColor: _selectedType == 1
                  ? Colors.green.shade100
                  : Colors.red.shade100,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Сумма',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _selectedMethod,
            decoration: const InputDecoration(
              labelText: 'Способ оплаты',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Наличные')),
              DropdownMenuItem(value: 2, child: Text('Карта/Терминал')),
              DropdownMenuItem(value: 3, child: Text('Перевод/СБП')),
            ],
            onChanged: (val) => setState(() => _selectedMethod = val!),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: 'Комментарий (опционально)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              final amount = int.tryParse(_amountController.text);
              if (amount != null && amount > 0) {
                context.read<ClientDetailsBloc>().add(
                  AddPaymentEvent(widget.clientId, {
                    'amount': amount,
                    'type': _selectedType,
                    'method': _selectedMethod,
                    'description': _descController.text,
                  }),
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
