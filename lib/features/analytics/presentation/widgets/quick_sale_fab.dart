import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/widgets/sections/quick_sale_sheet.dart';
import '../bloc/analytics_bloc.dart';
import '../bloc/analytics_event.dart';

class QuickSaleFab extends StatelessWidget {
  const QuickSaleFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'analytics_quick_sale',
      backgroundColor: Colors.orange,
      icon: const Icon(Icons.flash_on, color: Colors.white),
      label: const Text(
        'Продажа',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onPressed: () async {
        final clientsBloc = context.read<ClientsBloc>();
        final analyticsBloc = context.read<AnalyticsBloc>();

        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlocProvider.value(
            value: clientsBloc,
            child: const QuickSaleSheet(),
          ),
        );
        analyticsBloc.add(LoadAnalyticsEvent());
      },
    );
  }
}
