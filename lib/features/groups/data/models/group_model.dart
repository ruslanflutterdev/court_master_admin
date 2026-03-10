import 'student_model.dart';

class GroupModel {
  final String id;
  final String name;
  final String? scheduleText;
  final String coachName;
  final int studentsCount;
  final List<StudentModel>? students;

  GroupModel({
    required this.id,
    required this.name,
    this.scheduleText,
    required this.coachName,
    required this.studentsCount,
    this.students,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final coach = json['coach'];
    final coachFullName = coach != null
        ? '${coach['firstName']} ${coach['lastName']}'
        : 'Без тренера';

    List<StudentModel>? parsedStudents;
    if (json['students'] != null) {
      final List list = json['students'];
      parsedStudents = list.map((s) => StudentModel.fromJson(s)).toList();
    }

    final count = json['_count']?['students'] ?? parsedStudents?.length ?? 0;

    return GroupModel(
      id: json['id'],
      name: json['name'],
      scheduleText: json['scheduleText'],
      coachName: coachFullName,
      studentsCount: count,
      students: parsedStudents,
    );
  }
}
