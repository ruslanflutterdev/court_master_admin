import 'package:flutter/material.dart';

class ScheduleEventTypeSelector extends StatelessWidget {
  final String eventType;
  final Function(String) onTypeChanged;

  const ScheduleEventTypeSelector({
    super.key,
    required this.eventType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'group', label: Text('Групповая')),
        ButtonSegment(value: 'rent', label: Text('Аренда')),
      ],
      selected: {eventType},
      onSelectionChanged: (Set<String> newSelection) {
        onTypeChanged(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Colors.green.shade100,
      ),
    );
  }
}
