import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';
import '../bloc/analytics_state.dart';
import '../widgets/analytics_metrics_grid.dart';
import '../widgets/dashboard/simple_pie_chart.dart';
import '../widgets/quick_sale_fab.dart';

class AdminAnalyticsTab extends StatelessWidget {
  const AdminAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AnalyticsBloc>()..add(LoadAnalyticsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Сводка',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () =>
                    context.read<AnalyticsBloc>().add(LoadAnalyticsEvent()),
              ),
            ),
          ],
        ),
        floatingActionButton: const QuickSaleFab(),
        body: const AnalyticsContent(),
      ),
    );
  }
}

class AnalyticsContent extends StatelessWidget {
  const AnalyticsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        if (state is AnalyticsLoading)
          return const Center(child: CircularProgressIndicator());
        if (state is AnalyticsLoaded) {
          final d = state.data;
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<AnalyticsBloc>().add(LoadAnalyticsEvent()),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AnalyticsMetricsGrid(d: d),
                const SizedBox(height: 24),
                const Text(
                  'Выручка по кортам',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SimplePieChart(data: d.revenueByCourt),
                const SizedBox(height: 24),
                const Text(
                  'Выручка по тренерам',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SimplePieChart(data: d.revenueByCoach),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
