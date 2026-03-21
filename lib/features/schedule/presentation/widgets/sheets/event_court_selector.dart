import 'package:flutter/material.dart';
import '../../../data/models/court_model.dart';

class EventCourtSelector extends StatelessWidget {
  final String? selectedCourtId;
  final List<CourtModel> courts;
  final ValueChanged<String?> onChanged;

  const EventCourtSelector({
    super.key,
    required this.selectedCourtId,
    required this.courts,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Корт',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedCourtId,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.location_on, color: Colors.green),
          ),
          items: courts.map((court) {
            return DropdownMenuItem(value: court.id, child: Text(court.name));
          }).toList(),
          onChanged: onChanged,
          validator: (val) => val == null ? 'Выберите корт' : null,
        ),
      ],
    );
  }
}
