import 'package:flutter/material.dart';

import '../inputs/quick_sale_classes_selector.dart';
import '../inputs/quick_sale_coach_selector.dart';
import '../inputs/quick_sale_price_inputs.dart';
import '../inputs/quick_sale_purchase_inputs.dart';

class QuickSaleOrderSection extends StatelessWidget {
  final String saleType;
  final int paymentMethod;
  final int classesCount;
  final String? selectedCoachId;
  final Function(String) onTypeChanged;
  final Function(int) onMethodChanged;
  final Function(int) onClassesChanged;
  final Function(String?) onCoachChanged;
  final TextEditingController priceCtrl;
  final TextEditingController rentPriceCtrl;
  final TextEditingController coachPriceCtrl;

  const QuickSaleOrderSection({
    super.key,
    required this.saleType,
    required this.paymentMethod,
    required this.classesCount,
    required this.selectedCoachId,
    required this.onTypeChanged,
    required this.onMethodChanged,
    required this.onClassesChanged,
    required this.onCoachChanged,
    required this.priceCtrl,
    required this.rentPriceCtrl,
    required this.coachPriceCtrl,
  });

  @override
  Widget build(BuildContext context) {
    final needsCoach = [
      'indiv_training',
      'group_sub',
      'indiv_sub',
      'single',
    ].contains(saleType);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '2. Покупка',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        QuickSalePurchaseInputs(
          selectedSaleType: saleType,
          paymentMethod: paymentMethod,
          onSaleTypeChanged: onTypeChanged,
          onPaymentMethodChanged: onMethodChanged,
        ),
        QuickSaleClassesSelector(
          saleType: saleType,
          classesCount: classesCount,
          onChanged: onClassesChanged,
        ),
        if (needsCoach) ...[
          const SizedBox(height: 16),
          QuickSaleCoachSelector(
            selectedCoachId: selectedCoachId,
            onChanged: onCoachChanged,
          ),
        ],
        const SizedBox(height: 16),
        QuickSalePriceInputs(
          saleType: saleType,
          priceCtrl: priceCtrl,
          rentPriceCtrl: rentPriceCtrl,
          coachPriceCtrl: coachPriceCtrl,
        ),
      ],
    );
  }
}
