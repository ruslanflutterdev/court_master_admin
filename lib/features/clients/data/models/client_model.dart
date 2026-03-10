import 'payment_model.dart';
import 'subscription_model.dart';

class ClientModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final int balance;
  final int activeSubscriptionsCount;

  // Добавляем опциональные списки для детального профиля
  final List<SubscriptionModel>? subscriptions;
  final List<PaymentModel>? payments;

  ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.balance,
    required this.activeSubscriptionsCount,
    this.subscriptions,
    this.payments,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    List<SubscriptionModel>? parsedSubs;
    if (json['subscriptions'] != null) {
      parsedSubs = (json['subscriptions'] as List)
          .map((s) => SubscriptionModel.fromJson(s))
          .toList();
    }

    List<PaymentModel>? parsedPayments;
    if (json['payments'] != null) {
      parsedPayments = (json['payments'] as List)
          .map((p) => PaymentModel.fromJson(p))
          .toList();
    }

    return ClientModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      balance: json['balance'] ?? 0,
      activeSubscriptionsCount: json['_count']?['subscriptions'] ?? 0,
      subscriptions: parsedSubs,
      payments: parsedPayments,
    );
  }
}
