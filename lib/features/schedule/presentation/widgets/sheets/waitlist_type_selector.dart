import 'package:flutter/material.dart';

class WaitlistTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const WaitlistTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'RENTAL', label: Text('Аренда (Корт)')),
        ButtonSegment(value: 'GROUP', label: Text('В группу')),
      ],
      selected: {selectedType},
      onSelectionChanged: (val) => onChanged(val.first),
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Colors.blue.shade100,
      ),
    );
  }
}
