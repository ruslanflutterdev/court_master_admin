import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/client_details_bloc.dart';
import '../bloc/client_details_event.dart';
import '../bloc/client_details_state.dart';
import '../widgets/profile/client_action_buttons.dart';
import '../widgets/profile/client_attendance_list.dar.dart';
import '../widgets/profile/client_info_header.dart';
import '../widgets/profile/client_payments_list.dart';
import '../widgets/profile/client_subscriptions_list.dart';

class AdminClientDetailsScreen extends StatelessWidget {
  final String clientId;

  const AdminClientDetailsScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ClientDetailsBloc>()..add(LoadClientDetails(clientId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Профиль клиента'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Редактирование профиля будет доступно позже',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: DefaultTabController(
          length: 3,
          child: BlocBuilder<ClientDetailsBloc, ClientDetailsState>(
            builder: (context, state) {
              if (state is ClientDetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClientDetailsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is ClientDetailsLoaded) {
                final client = state.client;

                return Column(
                  children: [
                    ClientInfoHeader(client: client),
                    ClientActionButtons(clientId: clientId),
                    const TabBar(
                      tabs: [
                        Tab(text: 'Абонементы'),
                        Tab(text: 'Платежи'),
                        Tab(text: 'История'),
                      ],
                      labelColor: Colors.green,
                      unselectedLabelColor: Colors.grey,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          ClientSubscriptionsList(
                            subscriptions: client.subscriptions ?? [],
                          ),
                          ClientPaymentsList(payments: client.payments ?? []),
                          ClientAttendanceList(
                            attendances: client.attendances ?? [],
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
