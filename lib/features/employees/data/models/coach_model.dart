class CoachModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String? phone;
  final String? qualification;
  final String? specialization;
  final double rating;
  final String? salaryType;
  final int? salaryRate;

  CoachModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    this.phone,
    this.qualification,
    this.specialization,
    this.rating = 5.0,
    this.salaryType,
    this.salaryRate,
  });

  factory CoachModel.fromJson(Map<String, dynamic> json) {
    return CoachModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? 'Без имени',
      lastName: json['lastName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'tennisCoach',
      phone: json['phone']?.toString(),
      qualification: json['qualification']?.toString(),
      specialization: json['specialization']?.toString(),
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 5.0
          : 5.0,
      salaryType: json['salaryType']?.toString(),
      salaryRate: json['salaryRate'] != null
          ? int.tryParse(json['salaryRate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': role,
      'phone': phone,
      'qualification': qualification,
      'specialization': specialization,
      'rating': rating,
      'salaryType': salaryType,
      'salaryRate': salaryRate,
    };
  }
}
