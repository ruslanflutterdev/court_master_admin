import 'package:flutter/material.dart';

class ScheduleTimePickerRow extends StatelessWidget {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final Function(TimeOfDay) onStartTimeChanged;
  final Function(TimeOfDay) onEndTimeChanged;

  const ScheduleTimePickerRow({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
  });

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) onTimeSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text(
              'Начало',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            subtitle: Text(
              '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context, startTime, onStartTimeChanged),
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text(
              'Конец',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            subtitle: Text(
              '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16),
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () => _selectTime(context, endTime, onEndTimeChanged),
          ),
        ),
      ],
    );
  }
}
