import 'package:flutter/material.dart';
import '../../../data/models/coach_model.dart';

class EmployeeListCard extends StatelessWidget {
  final CoachModel coach;
  final VoidCallback onTap;

  const EmployeeListCard({super.key, required this.coach, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.sports_tennis, color: Colors.white),
        ),
        title: Text(
          '${coach.firstName} ${coach.lastName ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          coach.phone ?? 'Нет телефона',
        ), // Заменили email на phone
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
