import 'client_attendance_model.dart';
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

  final String? companyName;
  final String? skillLevel;
  final String? acquisitionSource;
  final String? notes;
  final List<String> tags;

  final List<SubscriptionModel>? subscriptions;
  final List<PaymentModel>? payments;
  final List<ClientAttendanceModel>? attendances;

  ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    required this.balance,
    required this.activeSubscriptionsCount,
    this.companyName,
    this.skillLevel,
    this.acquisitionSource,
    this.notes,
    this.tags = const [],
    this.subscriptions,
    this.payments,
    this.attendances,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      balance: json['balance'] ?? 0,
      activeSubscriptionsCount: json['_count']?['subscriptions'] ?? 0,
      companyName: json['companyName'],
      skillLevel: json['skillLevel'],
      acquisitionSource: json['acquisitionSource'],
      notes: json['notes'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      subscriptions: (json['subscriptions'] as List?)
          ?.map((s) => SubscriptionModel.fromJson(s))
          .toList(),
      payments: (json['payments'] as List?)
          ?.map((p) => PaymentModel.fromJson(p))
          .toList(),
      attendances: (json['attendances'] as List?)
          ?.map((a) => ClientAttendanceModel.fromJson(a))
          .toList(),
    );
  }
}
