class StudentModel {
  final String id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  StudentModel({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
