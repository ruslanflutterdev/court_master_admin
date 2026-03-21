import 'package:flutter/material.dart';

class QuickSalePriceField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const QuickSalePriceField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Введите сумму';
        if (int.tryParse(value) == null) return 'Ошибка';
        return null;
      },
    );
  }
}
