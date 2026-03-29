import '../../../employees/data/models/coach_model.dart';
import 'student_model.dart';

class GroupModel {
  final String id;
  final String name;
  final String scheduleText;
  final String coachId;
  final String? type;
  final int studentsCount;
  final CoachModel? coach;
  final List<StudentModel>? students;

  GroupModel({
    required this.id,
    required this.name,
    required this.scheduleText,
    required this.coachId,
    this.type,
    this.studentsCount = 0,
    this.coach,
    this.students,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final countMap = json['_count'] as Map<String, dynamic>?;
    final count = countMap != null ? countMap['students'] as int : 0;

    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scheduleText: json['scheduleText'] ?? '',
      coachId: json['coachId'] ?? '',
      type: json['type'],
      studentsCount: count,
      coach: json['coach'] != null ? CoachModel.fromJson(json['coach']) : null,
      students: json['students'] != null
          ? (json['students'] as List)
                .map((i) => StudentModel.fromJson(i))
                .toList()
          : [],
    );
  }
}
