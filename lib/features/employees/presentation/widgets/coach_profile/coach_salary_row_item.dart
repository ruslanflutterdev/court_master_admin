import 'package:flutter/material.dart';

class CoachSalaryRowItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double value;
  final bool isEditing;

  const CoachSalaryRowItem({
    super.key,
    required this.label,
    required this.controller,
    required this.value,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: isEditing
                ? SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(),
                        suffixText: '%',
                      ),
                    ),
                  )
                : Text(
                    '${value.toInt()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
