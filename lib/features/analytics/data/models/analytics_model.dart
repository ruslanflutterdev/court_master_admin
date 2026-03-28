import 'chart_data.dart';

class AnalyticsModel {
  final int monthlyRevenue;
  final int totalDebt;
  final int clientsCount;
  final int activeSubsCount;
  final List<ChartData> revenueByCourt;
  final List<ChartData> revenueByCoach;

  AnalyticsModel({
    required this.monthlyRevenue,
    required this.totalDebt,
    required this.clientsCount,
    required this.activeSubsCount,
    required this.revenueByCourt,
    required this.revenueByCoach,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      monthlyRevenue: json['monthlyRevenue'] ?? 0,
      totalDebt: json['totalDebt'] ?? 0,
      clientsCount: json['totalClients'] ?? 0,
      activeSubsCount: json['activeSubsCount'] ?? 0,
      revenueByCourt: (json['revenueByCourt'] as List? ?? [])
          .map((e) => ChartData.fromJson(e))
          .toList(),
      revenueByCoach: (json['revenueByCoach'] as List? ?? [])
          .map((e) => ChartData.fromJson(e))
          .toList(),
    );
  }
}
