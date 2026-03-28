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
    String rawRole = json['role']?.toString() ?? AppRoles.client;

    if (rawRole == 'SUPER_ADMIN') {
      rawRole = AppRoles.superAdmin;
    } else if (rawRole == 'HEAD_ADMIN') {
      rawRole = AppRoles.headAdmin;
    } else if (rawRole == 'ADMIN') {
      rawRole = AppRoles.admin;
    } else if (rawRole == 'COACH') {
      rawRole = AppRoles.coach;
    } else {
      rawRole = AppRoles.client;
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName:
          json['first_name']?.toString() ?? json['firstName']?.toString() ?? '',
      lastName:
          json['last_name']?.toString() ?? json['lastName']?.toString() ?? '',
      role: rawRole,
    );
  }
}
