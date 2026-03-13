import 'package:flutter/material.dart';

class ScheduleColorPickerRow extends StatelessWidget {
  final String selectedColor;
  final Function(String) onColorSelected;

  const ScheduleColorPickerRow({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  final Map<String, Color> colors = const {
    'blue': Colors.blue,
    'red': Colors.red,
    'green': Colors.green,
    'orange': Colors.orange,
    'purple': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors.entries.map((entry) {
          final isSelected = entry.key == selectedColor;
          return GestureDetector(
            onTap: () => onColorSelected(entry.key),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: entry.value.withAlpha(200),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black87 : Colors.transparent,
                  width: 2.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
