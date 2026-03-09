class CoachModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  CoachModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }
}