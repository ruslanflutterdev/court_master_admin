import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../data/models/analytics_model.dart';

class SimplePieChart extends StatelessWidget {
  final List<ChartData> data;

  const SimplePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("Нет данных")),
      );
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
          sections: data.asMap().entries.map((entry) {
            final colors = [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.purple,
              Colors.red,
            ];
            return PieChartSectionData(
              color: colors[entry.key % colors.length],
              value: entry.value.value,
              title: '${entry.value.name}\n${entry.value.value.toInt()} ₸',
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
