import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/client_details_bloc.dart';
import '../../bloc/client_details_event.dart';
import '../../utils/payment_helper.dart';

class AddPaymentSheet extends StatefulWidget {
  final String clientId;

  const AddPaymentSheet({super.key, required this.clientId});

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final amountCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  int selectedType = 1;
  int selectedMethod = 2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Добавить платеж',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: amountCtrl,
              decoration: const InputDecoration(labelText: 'Сумма (₸)'),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: selectedType,
              decoration: const InputDecoration(labelText: 'Тип операции'),
              items: [1, 2, 3]
                  .map(
                    (val) => DropdownMenuItem(
                      value: val,
                      child: Text(PaymentHelper.getTypeName(val)),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => selectedType = val!),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: selectedMethod,
              decoration: const InputDecoration(labelText: 'Способ оплаты'),
              items: [1, 2, 3]
                  .map(
                    (val) => DropdownMenuItem(
                      value: val,
                      child: Text(PaymentHelper.getMethodName(val)),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => selectedMethod = val!),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(
                labelText:
                    'Комментарий (например: "Оплата за Пакет 8 занятий")',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: PaymentHelper.getTypeColor(selectedType),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final amount = int.tryParse(amountCtrl.text) ?? 0;
                if (amount <= 0) return;

                context.read<ClientDetailsBloc>().add(
                  AddPaymentEvent(widget.clientId, {
                    'amount': amount,
                    'type': selectedType,
                    'method': selectedMethod,
                    'description': descCtrl.text.isEmpty ? null : descCtrl.text,
                  }),
                );
                Navigator.pop(context);
              },
              child: const Text('Провести платеж'),
            ),
          ],
        ),
      ),
    );
  }
}
