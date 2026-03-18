class AttendanceStudentModel {
  final String id;
  final String firstName;
  final String? lastName;
  final int balance;
  final int? attendanceStatus;

  AttendanceStudentModel({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.balance,
    this.attendanceStatus,
  });

  factory AttendanceStudentModel.fromJson(Map<String, dynamic> json) {
    int? status = json['attendanceStatus'] ?? json['status'];
    if (status == 0) status = null;

    return AttendanceStudentModel(
      id: json['id'] ?? json['studentId'] ?? '',
      firstName: json['firstName'] ?? 'Без имени',
      lastName: json['lastName'],
      balance: json['balance'] ?? 0,
      attendanceStatus: status,
    );
  }
}
