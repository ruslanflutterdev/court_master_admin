import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_dropdown.dart';
import '../../utils/payment_helper.dart';

class PaymentSelectors extends StatelessWidget {
  final int selectedType;
  final int selectedMethod;
  final ValueChanged<int?> onTypeChanged;
  final ValueChanged<int?> onMethodChanged;

  const PaymentSelectors({
    super.key,
    required this.selectedType,
    required this.selectedMethod,
    required this.onTypeChanged,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomDropdown<int>(
          label: 'Тип операции',
          value: selectedType,
          items: const [1, 2, 3],
          itemLabelBuilder: PaymentHelper.getTypeName,
          onChanged: onTypeChanged,
          prefixIcon: Icons.swap_horiz,
        ),
        CustomDropdown<int>(
          label: 'Способ оплаты',
          value: selectedMethod,
          items: const [1, 2, 3],
          itemLabelBuilder: PaymentHelper.getMethodName,
          onChanged: onMethodChanged,
          prefixIcon: Icons.account_balance,
        ),
      ],
    );
  }
}
