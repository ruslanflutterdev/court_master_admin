class AppRoles {
  static const String superAdmin = 'SUPER_ADMIN';
  static const String headAdmin = 'HEAD_ADMIN';
  static const String admin = 'ADMIN';
  static const String coach = 'COACH';
  static const String client = 'CLIENT';
}

class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String parsedRole = json['role'] ?? AppRoles.client;
    if (parsedRole == 'ADMIN') parsedRole = AppRoles.admin;
    if (parsedRole == 'COACH') parsedRole = AppRoles.coach;
    if (parsedRole == 'CLIENT' || parsedRole == 'CLIENT')
      parsedRole = AppRoles.client;

    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: parsedRole,
    );
  }
}
