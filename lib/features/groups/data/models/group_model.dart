class GroupModel {
  final String id;
  final String name;
  final String? scheduleText;
  final String coachName;
  final int studentsCount; 

  GroupModel({
    required this.id,
    required this.name,
    this.scheduleText,
    required this.coachName,
    required this.studentsCount,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    final coach = json['coach'];
    final coachFullName = coach != null
        ? '${coach['firstName']} ${coach['lastName']}'
        : 'Без тренера';

    return GroupModel(
      id: json['id'],
      name: json['name'],
      scheduleText: json['scheduleText'],
      coachName: coachFullName,
      studentsCount: json['_count']?['students'] ?? 0,
    );
  }
}