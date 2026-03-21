import 'package:flutter/material.dart';

class EventTimeSection extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final VoidCallback onSelectDate;
  final VoidCallback onSelectStartTime;
  final VoidCallback onSelectEndTime;

  const EventTimeSection({
    super.key,
    required this.selectedDate,
    required this.startTime,
    required this.endTime,
    required this.onSelectDate,
    required this.onSelectStartTime,
    required this.onSelectEndTime,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${selectedDate.day}.${selectedDate.month}.${selectedDate.year}";

    return Column(
      children: [
        ListTile(
          title: const Text(
            'Дата события',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(dateStr),
          trailing: const Icon(Icons.calendar_today, color: Colors.blue),
          onTap: onSelectDate,
        ),
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Начало'),
                subtitle: Text(startTime.format(context)),
                onTap: onSelectStartTime,
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Конец'),
                subtitle: Text(endTime.format(context)),
                onTap: onSelectEndTime,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
