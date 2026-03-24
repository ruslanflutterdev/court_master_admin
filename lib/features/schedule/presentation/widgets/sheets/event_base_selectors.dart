import 'package:flutter/material.dart';
import '../../../data/models/court_model.dart';

class EventBaseSelectors extends StatelessWidget {
  final String? coachId;
  final String? courtId;
  final List<CourtModel> courts;
  final ValueChanged<String?> onCoachChanged;
  final ValueChanged<String?> onCourtChanged;

  const EventBaseSelectors({
    super.key,
    required this.coachId,
    required this.courtId,
    required this.courts,
    required this.onCoachChanged,
    required this.onCourtChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          initialValue: courtId,
          decoration: const InputDecoration(
            labelText: 'Корт',
            border: OutlineInputBorder(),
          ),
          items: courts
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: onCourtChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
