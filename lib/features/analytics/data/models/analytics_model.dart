class AnalyticsModel {
  final int clientsCount;
  final int totalDebt;
  final int monthlyRevenue;
  final int activeSubsCount;

  AnalyticsModel({
    required this.clientsCount,
    required this.totalDebt,
    required this.monthlyRevenue,
    required this.activeSubsCount,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      clientsCount: json['clientsCount'] ?? 0,
      totalDebt: json['totalDebt'] ?? 0,
      monthlyRevenue: json['monthlyRevenue'] ?? 0,
      activeSubsCount: json['activeSubsCount'] ?? 0,
    );
  }
}
