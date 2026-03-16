import 'package:flutter/material.dart';
import '../../data/models/analytics_model.dart';
import 'metric_card.dart';

class AnalyticsMetricsGrid extends StatelessWidget {
  final AnalyticsModel d;

  const AnalyticsMetricsGrid({super.key, required this.d});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isDesktop ? 1.8 : 1.3,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        MetricCard(
          title: 'Выручка',
          value: '${d.monthlyRevenue} ₸',
          icon: Icons.wallet,
          color: Colors.green,
        ),
        MetricCard(
          title: 'Долги',
          value: '${d.totalDebt} ₸',
          icon: Icons.money_off,
          color: Colors.red,
        ),
        MetricCard(
          title: 'Ученики',
          value: '${d.clientsCount}',
          icon: Icons.people,
          color: Colors.blue,
        ),
        MetricCard(
          title: 'Абонементы',
          value: '${d.activeSubsCount}',
          icon: Icons.star,
          color: Colors.orange,
        ),
      ],
    );
  }
}
