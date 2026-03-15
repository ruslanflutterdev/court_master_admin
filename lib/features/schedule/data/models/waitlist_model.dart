class WaitlistModel {
  final String id;
  final DateTime date;
  final String startTime;
  final String endTime;
  final String? userId;
  final String? clientName;
  final String? clientPhone;
  final String status;

  WaitlistModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.userId,
    this.clientName,
    this.clientPhone,
    required this.status,
  });

  factory WaitlistModel.fromJson(Map<String, dynamic> json) {
    final resolvedName =
        json['clientName'] ??
        (json['user'] != null
            ? '${json['user']['firstName']} ${json['user']['lastName']}'
            : 'Неизвестно');

    final resolvedPhone = json['clientPhone'] ?? json['user']?['phone'];

    return WaitlistModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      userId: json['userId'],
      clientName: resolvedName,
      clientPhone: resolvedPhone,
      status: json['status'] ?? 'pending',
    );
  }
}
