import 'package:flutter/material.dart';
import '../../../data/models/coach_model.dart';

class EmployeeListCard extends StatelessWidget {
  final CoachModel coach;
  final VoidCallback onTap;

  const EmployeeListCard({super.key, required this.coach, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade50,
          child: const Icon(Icons.sports_tennis, color: Colors.blue, size: 28),
        ),
        title: Text(
          '${coach.firstName} ${coach.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              coach.specialization ?? 'Специализация не указана',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${coach.rating}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.phone, color: Colors.grey, size: 14),
                const SizedBox(width: 4),
                Text(
                  coach.phone ?? 'Нет телефона',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
