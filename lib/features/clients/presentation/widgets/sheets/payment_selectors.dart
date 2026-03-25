import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_dropdown.dart';
import '../../utils/payment_helper.dart';

class PaymentSelectors extends StatelessWidget {
  final String selectedType;
  final String selectedMethod;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String?> onMethodChanged;

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
        CustomDropdown<String>(
          label: 'Тип операции',
          value: selectedType,
          items: const [PaymentHelper.typeIncome, PaymentHelper.typeExpense],
          itemLabelBuilder: PaymentHelper.getTypeName,
          onChanged: onTypeChanged,
          prefixIcon: Icons.swap_horiz,
        ),
        CustomDropdown<String>(
          label: 'Способ оплаты',
          value: selectedMethod,
          items: const [
            PaymentHelper.methodCash,
            PaymentHelper.methodCard,
            PaymentHelper.methodTransfer,
            PaymentHelper.methodQr,
            PaymentHelper.methodSbp,
            PaymentHelper.methodDeposit,
          ],
          itemLabelBuilder: PaymentHelper.getMethodName,
          onChanged: onMethodChanged,
          prefixIcon: Icons.account_balance,
        ),
      ],
    );
  }
}
