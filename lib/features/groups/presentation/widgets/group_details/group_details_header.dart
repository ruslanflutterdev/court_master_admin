import 'package:flutter/material.dart';
import '../../../../groups/data/models/group_model.dart';

class GroupDetailsHeader extends StatelessWidget {
  final GroupModel group;

  const GroupDetailsHeader({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final studentsCount = group.students?.length ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.orange.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Тренер: ${group.coach?.firstName ?? 'Не назначен'}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Расписание: ${group.scheduleText}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(
              'Учеников: $studentsCount',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
