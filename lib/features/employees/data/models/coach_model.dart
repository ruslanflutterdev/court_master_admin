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
  final double indivStateTaxRate;
  final double indivClubTaxRate;
  final double groupStateTaxRate;
  final double groupClubTaxRate;
  final double singleStateTaxRate;
  final double singleClubTaxRate;

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
    this.indivStateTaxRate = 0.0,
    this.indivClubTaxRate = 0.0,
    this.groupStateTaxRate = 0.0,
    this.groupClubTaxRate = 0.0,
    this.singleStateTaxRate = 0.0,
    this.singleClubTaxRate = 0.0,
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
      rating: double.tryParse(json['rating']?.toString() ?? '5.0') ?? 5.0,

      // Читаем новые 6 полей с бекенда
      indivStateTaxRate:
          double.tryParse(json['indivStateTaxRate']?.toString() ?? '0') ?? 0.0,
      indivClubTaxRate:
          double.tryParse(json['indivClubTaxRate']?.toString() ?? '0') ?? 0.0,

      groupStateTaxRate:
          double.tryParse(json['groupStateTaxRate']?.toString() ?? '0') ?? 0.0,
      groupClubTaxRate:
          double.tryParse(json['groupClubTaxRate']?.toString() ?? '0') ?? 0.0,

      singleStateTaxRate:
          double.tryParse(json['singleStateTaxRate']?.toString() ?? '0') ?? 0.0,
      singleClubTaxRate:
          double.tryParse(json['singleClubTaxRate']?.toString() ?? '0') ?? 0.0,
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
      'indivStateTaxRate': indivStateTaxRate,
      'indivClubTaxRate': indivClubTaxRate,
      'groupStateTaxRate': groupStateTaxRate,
      'groupClubTaxRate': groupClubTaxRate,
      'singleStateTaxRate': singleStateTaxRate,
      'singleClubTaxRate': singleClubTaxRate,
    };
  }
}
