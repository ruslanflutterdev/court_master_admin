import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/client_details_bloc.dart';
import '../sheets/add_subscription_sheet.dart';
import '../sheets/add_payment_sheet.dart';

class ClientActionButtons extends StatelessWidget {
  final String clientId;

  const ClientActionButtons({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<ClientDetailsBloc>(),
                  child: AddSubscriptionSheet(clientId: clientId),
                ),
              ),
              icon: const Icon(Icons.card_membership),
              label: const Text('Абонемент'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: context.read<ClientDetailsBloc>(),
                  child: AddPaymentSheet(clientId: clientId),
                ),
              ),
              icon: const Icon(Icons.payment),
              label: const Text('Платеж'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
