import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../../core/presentation/widgets/primary_button.dart';
import '../../bloc/client_details_bloc.dart';
import '../../bloc/client_details_event.dart';
import '../../utils/payment_helper.dart';
import 'payment_selectors.dart';

class AddPaymentSheet extends StatefulWidget {
  final String clientId;
  const AddPaymentSheet({super.key, required this.clientId});

  @override
  State<AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<AddPaymentSheet> {
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  int _selectedType = 1;
  int _selectedMethod = 2;

  void _submit() {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;
    if (amount <= 0) return;

    context.read<ClientDetailsBloc>().add(
      AddPaymentEvent(widget.clientId, {
        'amount': amount,
        'type': _selectedType,
        'method': _selectedMethod,
        'description': _descCtrl.text.trim().isEmpty
            ? null
            : _descCtrl.text.trim(),
      }),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Добавить платеж',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            CustomTextField(
              controller: _amountCtrl,
              label: 'Сумма (₸)',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.account_balance_wallet,
            ),
            PaymentSelectors(
              selectedType: _selectedType,
              selectedMethod: _selectedMethod,
              onTypeChanged: (v) => setState(() => _selectedType = v ?? 1),
              onMethodChanged: (v) => setState(() => _selectedMethod = v ?? 2),
            ),
            CustomTextField(
              controller: _descCtrl,
              label: 'Комментарий',
              prefixIcon: Icons.description,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Провести платеж',
              color: PaymentHelper.getTypeColor(_selectedType),
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
