import 'package:flutter/material.dart';

import '../../../data/models/coach_model.dart';

class CoachProfileHeader extends StatelessWidget {
  final CoachModel coach;

  const CoachProfileHeader({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(Icons.sports_tennis, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            '${coach.firstName} ${coach.lastName}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (coach.specialization != null)
            Text(
              coach.specialization!,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}
