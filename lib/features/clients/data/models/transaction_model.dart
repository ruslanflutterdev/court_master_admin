class TransactionModel {
  final String id;
  final int amount;
  final String
  type; // 'income' (Приход), 'expense' (Расход), 'refund' (Возврат)
  final String category; // 'subscription', 'deposit', 'rent' и т.д.
  final String paymentMethod; // 'cash', 'card', 'transfer', 'deposit'
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
      amount: json['amount'],
      type: json['type'] ?? 'income',
      category: json['category'] ?? 'other',
      paymentMethod: json['paymentMethod'] ?? 'cash',
      status: json['status'] ?? 'completed',
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
