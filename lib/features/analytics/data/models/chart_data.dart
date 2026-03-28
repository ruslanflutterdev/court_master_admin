class ChartData {
  final String name;
  final double value;

  ChartData({required this.name, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      ChartData(name: json['name'], value: (json['value'] ?? 0).toDouble());
}
