import 'package:flutter/material.dart';
import '../../utils/subscription_helper.dart';

class SubscriptionTypeSelector extends StatelessWidget {
  final int selectedType;
  final ValueChanged<int?> onChanged;

  const SubscriptionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final types = List.generate(7, (index) => index + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          initialValue: selectedType,
          decoration: const InputDecoration(
            labelText: 'Тип абонемента',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          items: types.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(SubscriptionHelper.getTypeName(type)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 12, left: 4),
          child: Text(
            SubscriptionHelper.getTypeDescription(selectedType),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
