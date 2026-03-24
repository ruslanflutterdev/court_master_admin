import 'package:court_master_admin/features/clients/presentation/widgets/inputs/quick_sale_price_field.dart';
import 'package:flutter/material.dart';

class QuickSalePriceInputs extends StatelessWidget {
  final String saleType;
  final TextEditingController priceCtrl;
  final TextEditingController rentPriceCtrl;
  final TextEditingController coachPriceCtrl;

  const QuickSalePriceInputs({
    super.key,
    required this.saleType,
    required this.priceCtrl,
    required this.rentPriceCtrl,
    required this.coachPriceCtrl,
  });

  @override
  Widget build(BuildContext context) {
    if (saleType == 'indiv_training') {
      return Row(
        children: [
          Expanded(
            child: QuickSalePriceField(
              controller: rentPriceCtrl,
              label: 'Аренда (₸)',
              icon: Icons.sports_tennis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: QuickSalePriceField(
              controller: coachPriceCtrl,
              label: 'Тренеру (₸)',
              icon: Icons.person,
            ),
          ),
        ],
      );
    }
    return QuickSalePriceField(
      controller: priceCtrl,
      label: 'Сумма к оплате (₸)',
      icon: Icons.attach_money,
    );
  }
}
