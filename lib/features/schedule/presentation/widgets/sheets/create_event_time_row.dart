import 'package:flutter/material.dart';

class CreateEventTimeRow extends StatelessWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final VoidCallback onSelectStart;
  final VoidCallback onSelectEnd;

  const CreateEventTimeRow({
    super.key,
    required this.start,
    required this.end,
    required this.onSelectStart,
    required this.onSelectEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: const Text('Начало', style: TextStyle(fontSize: 12)),
            subtitle: Text(start.format(context)),
            onTap: onSelectStart,
          ),
        ),
        Expanded(
          child: ListTile(
            title: const Text('Конец', style: TextStyle(fontSize: 12)),
            subtitle: Text(end.format(context)),
            onTap: onSelectEnd,
          ),
        ),
      ],
    );
  }
}
