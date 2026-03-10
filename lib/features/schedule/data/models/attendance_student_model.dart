class AttendanceStudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final int balance;
  final int?
  attendanceStatus; // 1 = Был, 2 = Не был, 3 = Уважительная, null = Не отмечали

  AttendanceStudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.balance,
    this.attendanceStatus,
  });

  factory AttendanceStudentModel.fromJson(Map<String, dynamic> json) {
    return AttendanceStudentModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      balance: json['balance'] ?? 0,
      attendanceStatus: json['attendanceStatus'],
    );
  }
}
