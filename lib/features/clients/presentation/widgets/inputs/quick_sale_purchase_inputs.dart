import 'package:flutter/material.dart';

class QuickSalePurchaseInputs extends StatelessWidget {
  final int subType;
  final ValueChanged<int> onSubTypeChanged;
  final TextEditingController classesController;
  final TextEditingController priceController;
  final int paymentMethod;
  final ValueChanged<int> onPaymentMethodChanged;

  const QuickSalePurchaseInputs({
    super.key,
    required this.subType,
    required this.onSubTypeChanged,
    required this.classesController,
    required this.priceController,
    required this.paymentMethod,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<int>(
          initialValue: subType,
          decoration: const InputDecoration(
            labelText: 'Что продаем?',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 1, child: Text('Разовое занятие / Аренда')),
            DropdownMenuItem(
              value: 2,
              child: Text('Пакет занятий (Абонемент)'),
            ),
          ],
          onChanged: (val) {
            if (val != null) onSubTypeChanged(val);
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            if (subType == 2) ...[
              Expanded(
                child: TextField(
                  controller: classesController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Кол-во',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              flex: 2,
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Сумма (₸)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: paymentMethod,
          decoration: const InputDecoration(
            labelText: 'Способ оплаты',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 1, child: Text('Наличные')),
            DropdownMenuItem(value: 2, child: Text('Карта / Терминал')),
            DropdownMenuItem(value: 3, child: Text('Перевод / СБП')),
          ],
          onChanged: (val) {
            if (val != null) onPaymentMethodChanged(val);
          },
        ),
      ],
    );
  }
}
