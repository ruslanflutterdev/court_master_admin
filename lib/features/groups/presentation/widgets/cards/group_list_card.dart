import 'package:flutter/material.dart';
import '../../../data/models/group_model.dart';

class GroupListCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onTap;

  const GroupListCard({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withAlpha(51),
          child: const Icon(Icons.group, color: Colors.orange),
        ),
        title: Text(
          group.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Тренер: ${group.coach?.firstName ?? 'Не назначен'}\nРасписание: ${group.scheduleText}',
        ),
        trailing: Chip(
          label: Text(
            '${group.students?.length ?? 0} чел.',
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: Colors.green.withAlpha(51),
        ),
        onTap: onTap,
      ),
    );
  }
}
