import 'subscription_model.dart';
import 'transaction_model.dart';
import 'client_attendance_model.dart';

class ClientModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final int balance;

  final bool isCorporate;
  final String? companyName;
  final String? inn;
  final String? kpp;
  final String? skillLevel;
  final String? acquisitionSource;
  final String? notes;
  final List<String> tags;

  final int? activeSubscriptionsCount;
  final List<SubscriptionModel>? subscriptions;
  final List<TransactionModel>? transactions;
  final List<ClientAttendanceModel>? attendances;
  final int totalSpent;
  final bool hasRent;

  ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    required this.balance,
    this.isCorporate = false,
    this.companyName,
    this.inn,
    this.kpp,
    this.skillLevel,
    this.acquisitionSource,
    this.notes,
    this.tags = const [],
    this.activeSubscriptionsCount,
    this.subscriptions,
    this.transactions,
    this.attendances,
    this.totalSpent = 0,
    this.hasRent = false,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      balance: json['balance'] ?? 0,
      isCorporate: json['isCorporate'] ?? false,
      inn: json['inn'],
      kpp: json['kpp'],
      activeSubscriptionsCount: json['_count']?['subscriptions'],
      totalSpent: json['totalSpent'] ?? 0,
      hasRent: json['hasRent'] ?? false,
      companyName: json['companyName'],
      skillLevel: json['skillLevel'],
      acquisitionSource: json['acquisitionSource'],
      notes: json['notes'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],

      subscriptions: json['subscriptions'] != null
          ? (json['subscriptions'] as List)
                .map((i) => SubscriptionModel.fromJson(i))
                .toList()
          : null,

      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
                .map((i) => TransactionModel.fromJson(i))
                .toList()
          : null,

      attendances: json['attendances'] != null
          ? (json['attendances'] as List)
                .map((i) => ClientAttendanceModel.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'isCorporate': isCorporate,
      'companyName': companyName,
      'inn': inn,
      'kpp': kpp,
      'skillLevel': skillLevel,
      'acquisitionSource': acquisitionSource,
      'notes': notes,
      'tags': tags,
    };
  }
}
