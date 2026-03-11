class CoachModel {
  final String id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  CoachModel({
    required this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}
