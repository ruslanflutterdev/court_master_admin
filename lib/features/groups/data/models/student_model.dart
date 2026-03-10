class StudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  StudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}
