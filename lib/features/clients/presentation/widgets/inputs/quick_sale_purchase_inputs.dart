import 'package:flutter/material.dart';

final Map<String, String> saleTypes = {
  'rent': 'Аренда корта',
  'single': 'Разовое занятие',
  'group_sub': 'Членский взнос (Групповая тренировка)',
  'indiv_sub': 'Членский взнос (Индивидуальное занятие)',
  'deposit': 'Пополнение депозита',
};

class QuickSalePurchaseInputs extends StatelessWidget {
  final String selectedSaleType;
  final int paymentMethod;
  final Function(String) onSaleTypeChanged;
  final Function(int) onPaymentMethodChanged;

  const QuickSalePurchaseInputs({
    super.key,
    required this.selectedSaleType,
    required this.paymentMethod,
    required this.onSaleTypeChanged,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Тип операции', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: selectedSaleType,
          decoration: InputDecoration(
            labelText: 'Что продаем?',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: saleTypes.entries.map((entry) {
            return DropdownMenuItem(value: entry.key, child: Text(entry.value));
          }).toList(),
          onChanged: (val) {
            if (val != null) onSaleTypeChanged(val);
          },
        ),

        const SizedBox(height: 16),

        const Text('Способ оплаты', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: paymentMethod,
          decoration: InputDecoration(
            labelText: 'Как оплачивает?',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.grey.shade50,
          ),
          items: const [
            DropdownMenuItem(value: 1, child: Text('Наличные')),
            DropdownMenuItem(value: 2, child: Text('Карта (Терминал)')),
            DropdownMenuItem(value: 3, child: Text('Перевод (Kaspi/СБП)')),
            DropdownMenuItem(value: 4, child: Text('QR-код')),
          ],
          onChanged: (val) {
            if (val != null) onPaymentMethodChanged(val);
          },
        ),
      ],
    );
  }
}