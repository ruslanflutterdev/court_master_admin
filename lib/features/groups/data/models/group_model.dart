import '../../../employees/data/models/coach_model.dart';
import 'student_model.dart';

class GroupModel {
  final String id;
  final String name;
  final String scheduleText;
  final String coachId;
  final CoachModel? coach;
  final List<StudentModel>? students;

  GroupModel({
    required this.id,
    required this.name,
    required this.scheduleText,
    required this.coachId,
    this.coach,
    this.students,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      scheduleText: json['scheduleText'] ?? '',
      coachId: json['coachId'] ?? '',

      coach: json['coach'] != null ? CoachModel.fromJson(json['coach']) : null,

      students: json['students'] != null
          ? (json['students'] as List)
                .map((i) => StudentModel.fromJson(i))
                .toList()
          : [],
    );
  }
}
