import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final String label;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;

  const CustomDropdown({
    super.key,
    this.value,
    required this.label,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items
            .map(
              (val) => DropdownMenuItem<T>(
                value: val,
                child: Text(itemLabelBuilder(val)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
