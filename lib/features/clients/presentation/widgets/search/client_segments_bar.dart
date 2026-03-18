import 'package:flutter/material.dart';
import '../../bloc/clients_state.dart';

class ClientSegmentsBar extends StatelessWidget {
  final ClientSegment selectedSegment;
  final Function(ClientSegment) onSegmentChanged;

  const ClientSegmentsBar({
    super.key,
    required this.selectedSegment,
    required this.onSegmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _SegmentChip(
            label: 'Все',
            isSelected: selectedSegment == ClientSegment.all,
            onTap: () => onSegmentChanged(ClientSegment.all),
          ),
          _SegmentChip(
            label: 'Должники',
            isSelected: selectedSegment == ClientSegment.debtors,
            color: Colors.red,
            onTap: () => onSegmentChanged(ClientSegment.debtors),
          ),
          _SegmentChip(
            label: 'Членские взносы',
            isSelected: selectedSegment == ClientSegment.sub,
            color: Colors.orange,
            onTap: () => onSegmentChanged(ClientSegment.sub),
          ),
          _SegmentChip(
            label: 'Аренда',
            isSelected: selectedSegment == ClientSegment.rent,
            color: Colors.blue,
            onTap: () => onSegmentChanged(ClientSegment.rent),
          ),
          _SegmentChip(
            label: 'Депозит',
            isSelected: selectedSegment == ClientSegment.deposit,
            color: Colors.green,
            onTap: () => onSegmentChanged(ClientSegment.deposit),
          ),
        ],
      ),
    );
  }
}

class _SegmentChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _SegmentChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: color.withAlpha(40),
        labelStyle: TextStyle(
          color: isSelected ? color : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
