import 'package:flutter/material.dart';

class ScheduleColorPickerRow extends StatelessWidget {
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  const ScheduleColorPickerRow({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  static const List<String> availableColors = [
    '#2196F3', // Blue (Синий)
    '#4CAF50', // Green (Зеленый)
    '#FF9800', // Orange (Оранжевый)
    '#9C27B0', // Purple (Фиолетовый)
    '#E91E63', // Pink (Розовый)
    '#009688', // Teal (Бирюзовый)
    '#3F51B5', // Indigo (Индиго)
    '#FF5722', // Deep Orange (Темно-оранжевый)
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          const Text('Цвет: ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableColors.map((hex) {
                  final isSelected =
                      selectedColor.toUpperCase() == hex.toUpperCase();
                  final colorValue = Color(
                    int.parse(hex.substring(1, 7), radix: 16) + 0xFF000000,
                  );

                  return GestureDetector(
                    onTap: () => onColorSelected(hex),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorValue,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black87, width: 3)
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
