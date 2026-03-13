import 'package:flutter/material.dart';

class ScheduleRecurrenceForm extends StatelessWidget {
  final bool isRecurring;
  final int recurrenceWeeks;
  final ValueChanged<bool> onRecurringChanged;
  final ValueChanged<int> onWeeksChanged;

  const ScheduleRecurrenceForm({
    super.key,
    required this.isRecurring,
    required this.recurrenceWeeks,
    required this.onRecurringChanged,
    required this.onWeeksChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Повторять каждую неделю (Регулярно)'),
          value: isRecurring,
          onChanged: (val) => onRecurringChanged(val ?? false),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (isRecurring)
          Padding(
            padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'На сколько недель вперед?',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              initialValue: recurrenceWeeks,
              items: [1, 2, 4, 8, 12].map((w) {
                return DropdownMenuItem(value: w, child: Text('$w недель'));
              }).toList(),
              onChanged: (val) {
                if (val != null) onWeeksChanged(val);
              },
            ),
          ),
      ],
    );
  }
}
