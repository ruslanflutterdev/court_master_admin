class SubscriptionModel {
  final String id;
  final int type; // 1 = Разовое, 2 = Пакет, 3 = Безлимит
  final int status; // 1 = Активен, 2 = Завершен
  final int totalClasses;
  final int usedClasses;
  final int price;
  final DateTime? validUntil;
  final DateTime createdAt;

  SubscriptionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.totalClasses,
    required this.usedClasses,
    required this.price,
    this.validUntil,
    required this.createdAt,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'],
      type: json['type'],
      status: json['status'],
      totalClasses: json['totalClasses'],
      usedClasses: json['usedClasses'],
      price: json['price'],
      validUntil: json['validUntil'] != null
          ? DateTime.parse(json['validUntil'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
