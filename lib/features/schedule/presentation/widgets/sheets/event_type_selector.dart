import 'package:flutter/material.dart';

class EventTypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String?> onChanged;

  const EventTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Тип события',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedType,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              selectedType == 'training'
                  ? Icons.sports_tennis
                  : selectedType == 'rent'
                  ? Icons.vpn_key
                  : Icons.group,
              color: Colors.orange,
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'rent', child: Text('Аренда корта')),
            DropdownMenuItem(value: 'group', child: Text('Групповое занятие')),
            DropdownMenuItem(value: 'tournament', child: Text('Турнир')),
            DropdownMenuItem(
              value: 'maintenance',
              child: Text('Технические работы'),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
