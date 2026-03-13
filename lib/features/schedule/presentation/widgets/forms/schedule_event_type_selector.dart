import 'package:flutter/material.dart';

class ScheduleEventTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onChanged;

  const ScheduleEventTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Тип события'),
      initialValue: selectedType,
      items: const [
        DropdownMenuItem(value: 'rent', child: Text('Аренда корта')),
        DropdownMenuItem(
          value: 'individual',
          child: Text('Индивидуальная тренировка'),
        ),
        DropdownMenuItem(value: 'group', child: Text('Групповая тренировка')),
        DropdownMenuItem(
          value: 'tournament',
          child: Text('🏆 Турнир (Блокировка)'),
        ),
        DropdownMenuItem(
          value: 'maintenance',
          child: Text('🔧 Техобслуживание (Блокировка)'),
        ),
      ],
      onChanged: (val) {
        if (val != null) {
          onChanged(val);
        }
      },
    );
  }
}
