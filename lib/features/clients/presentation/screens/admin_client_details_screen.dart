import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/client_details_bloc.dart';
import '../bloc/client_details_event.dart';
import '../bloc/client_details_state.dart';
import '../widgets/profile/client_info_header.dart';
import '../widgets/profile/client_action_buttons.dart';
import '../widgets/profile/client_subscriptions_list.dart';
import '../widgets/profile/client_payments_list.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminClientDetailsScreen extends StatelessWidget {
  final String clientId;

  const AdminClientDetailsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ClientDetailsBloc>()..add(LoadClientDetails(clientId)),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Профиль клиента'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Абонементы'),
                Tab(text: 'История оплат'),
              ],
            ),
          ),
          body: BlocBuilder<ClientDetailsBloc, ClientDetailsState>(
            builder: (context, state) {
              if (state is ClientDetailsLoading)
                return const Center(child: CircularProgressIndicator());
              if (state is ClientDetailsError)
                return Center(
                  child: Text(
                    'Ошибка: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );

              if (state is ClientDetailsLoaded) {
                return Column(
                  children: [
                    ClientInfoHeader(client: state.client),
                    ClientActionButtons(clientId: clientId),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ClientSubscriptionsList(
                            subscriptions: state.client.subscriptions ?? [],
                          ),
                          ClientPaymentsList(
                            payments: state.client.payments ?? [],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
