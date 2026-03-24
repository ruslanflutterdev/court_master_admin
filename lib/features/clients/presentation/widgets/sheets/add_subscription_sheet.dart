import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../../core/presentation/widgets/primary_button.dart';
import '../../bloc/client_details_bloc.dart';
import '../../bloc/client_details_event.dart';
import '../../utils/subscription_helper.dart';
import 'subscription_type_selector.dart';

class AddSubscriptionSheet extends StatefulWidget {
  final String clientId;

  const AddSubscriptionSheet({super.key, required this.clientId});

  @override
  State<AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<AddSubscriptionSheet> {
  int _selectedType = 2;
  final _classesCtrl = TextEditingController(text: '8');
  final _priceCtrl = TextEditingController();
  DateTime? _validUntil;

  void _submit() {
    int totalClasses = int.tryParse(_classesCtrl.text) ?? 1;
    if (_selectedType == 1) totalClasses = 1;
    if (_selectedType == 3) totalClasses = 9999;

    context.read<ClientDetailsBloc>().add(
      AddSubscriptionEvent(widget.clientId, {
        'type': _selectedType,
        'totalClasses': totalClasses,
        'price': int.tryParse(_priceCtrl.text) ?? 0,
        if (_validUntil != null) 'validUntil': _validUntil!.toIso8601String(),
      }),
    );
    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (date != null) setState(() => _validUntil = date);
  }

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
          children: [
            const Text(
              'Оформить абонемент',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 32),
            SubscriptionTypeSelector(
              selectedType: _selectedType,
              onChanged: (val) => setState(() => _selectedType = val ?? 2),
            ),
            if (SubscriptionHelper.requiresManualClassCount(_selectedType))
              CustomTextField(
                controller: _classesCtrl,
                label: 'Количество занятий',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.repeat,
              ),
            CustomTextField(
              controller: _priceCtrl,
              label: 'Стоимость (₸)',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.payments,
            ),
            ListTile(
              title: Text(
                _validUntil == null
                    ? 'Срок: Не ограничен'
                    : 'До: ${_validUntil!.day}.${_validUntil!.month}.${_validUntil!.year}',
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.blue),
              onTap: _selectDate,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Сохранить абонемент',
              color: Colors.blue,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
