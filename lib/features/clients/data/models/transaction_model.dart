class TransactionModel {
  final String id;
  final int amount;
  final String type; // 'INCOME', 'EXPENSE', 'REFUND'
  final String category; // 'SUBSCRIPTION', 'DEPOSIT', 'RENT', etc.
  final String
  paymentMethod; // 'CASH', 'CARD', 'TRANSFER', 'QR', 'SBP', 'DEPOSIT'
  final String status;
  final String? description;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.paymentMethod,
    required this.status,
    this.description,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      amount: json['amount'] is int
          ? json['amount']
          : (json['amount'] as num).toInt(),
      type: json['type']?.toString().toUpperCase() ?? 'INCOME',
      category: json['category']?.toString().toUpperCase() ?? 'OTHER',
      paymentMethod: json['paymentMethod']?.toString().toUpperCase() ?? 'CASH',
      status: json['status']?.toString().toUpperCase() ?? 'COMPLETED',
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
