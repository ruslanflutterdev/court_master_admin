class WaitlistModel {
  final String id;
  final String type;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? userId;
  final String? clientName;
  final String? lastName;
  final String? clientPhone;
  final String? gameLevel;
  final String? ageGroup;
  final String? comment;
  final String status;

  WaitlistModel({
    required this.id,
    this.type = 'RENTAL',
    this.date,
    this.startTime,
    this.endTime,
    this.userId,
    this.clientName,
    this.lastName,
    this.clientPhone,
    this.gameLevel,
    this.ageGroup,
    this.comment,
    required this.status,
  });

  factory WaitlistModel.fromJson(Map<String, dynamic> json) {
    final resolvedName =
        json['clientName'] ??
        (json['user'] != null ? json['user']['firstName'] : 'Неизвестно');

    final resolvedLastName = json['lastName'] ?? json['user']?['lastName'];
    final resolvedPhone = json['clientPhone'] ?? json['user']?['phone'];

    return WaitlistModel(
      id: json['id'],
      type: json['type'] ?? 'RENTAL',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      userId: json['userId'],
      clientName: resolvedName,
      lastName: resolvedLastName,
      clientPhone: resolvedPhone,
      gameLevel: json['gameLevel'],
      ageGroup: json['ageGroup'],
      comment: json['comment'],
      status: json['status'] ?? 'pending',
    );
  }
}
