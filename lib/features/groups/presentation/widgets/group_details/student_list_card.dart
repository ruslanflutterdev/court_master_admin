import 'package:flutter/material.dart';
import '../../../../groups/data/models/student_model.dart';

class StudentListCard extends StatelessWidget {
  final StudentModel student;

  const StudentListCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withAlpha(51),
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          '${student.firstName} ${student.lastName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(student.phone ?? 'Нет телефона'),
      ),
    );
  }
}
