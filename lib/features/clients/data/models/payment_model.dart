class PaymentModel {
  final String id;
  final int amount;
  final int type; // 1 = Внесение, 2 = Списание, 3 = Возврат
  final int method; // 1 = Наличные, 2 = Карта, 3 = СБП
  final String? description;
  final DateTime createdAt;

  PaymentModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.method,
    this.description,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      amount: json['amount'],
      type: json['type'],
      method: json['method'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
