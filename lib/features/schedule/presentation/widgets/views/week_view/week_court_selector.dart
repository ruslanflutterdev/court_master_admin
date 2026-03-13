import 'package:flutter/material.dart';
import '../../../../data/models/court_model.dart';

class WeekCourtSelector extends StatelessWidget {
  final List<CourtModel> courts;
  final String? selectedCourtId;
  final ValueChanged<String?> onChanged;

  const WeekCourtSelector({
    super.key,
    required this.courts,
    required this.selectedCourtId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Text(
            'Выберите корт: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedCourtId,
            items: courts
                .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
