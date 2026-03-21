import 'package:flutter/material.dart';

class QuickSaleClassesSelector extends StatelessWidget {
  final String saleType;
  final int classesCount;
  final ValueChanged<int> onChanged;

  const QuickSaleClassesSelector({
    super.key,
    required this.saleType,
    required this.classesCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (saleType != 'group_sub') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Пакет тренировок (на 4 недели)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 8, label: Text('8 занятий')),
              ButtonSegment(value: 12, label: Text('12 занятий')),
            ],
            selected: {classesCount},
            onSelectionChanged: (newSelection) => onChanged(newSelection.first),
          ),
        ],
      ),
    );
  }
}
