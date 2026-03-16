import 'package:flutter/material.dart';
import '../../../../groups/data/models/student_model.dart';
import 'student_list_card.dart';

class GroupStudentsList extends StatelessWidget {
  final List<StudentModel> students;

  const GroupStudentsList({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Center(child: Text('В группе пока нет учеников'));
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        return StudentListCard(student: students[index]);
      },
    );
  }
}
