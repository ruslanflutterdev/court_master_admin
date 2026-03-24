import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/client_details_bloc.dart';
import '../bloc/client_details_event.dart';
import '../bloc/client_details_state.dart';
import '../widgets/profile/client_info_header.dart';
import '../widgets/profile/client_action_buttons.dart';
import '../widgets/profile/client_stats_cards.dart';
import '../widgets/profile/client_details_tabs.dart';

class AdminClientDetailsScreen extends StatefulWidget {
  final String clientId;
  const AdminClientDetailsScreen({super.key, required this.clientId});

  @override
  State<AdminClientDetailsScreen> createState() =>
      _AdminClientDetailsScreenState();
}

class _AdminClientDetailsScreenState extends State<AdminClientDetailsScreen> {
  late final ClientDetailsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<ClientDetailsBloc>();
    _loadClient();
  }

  void _loadClient() {
    _bloc.add(LoadClientDetails(clientId: widget.clientId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Карточка клиента')),
      body: BlocProvider.value(
        value: _bloc,
        child: BlocBuilder<ClientDetailsBloc, ClientDetailsState>(
          builder: (context, state) {
            if (state is ClientDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ClientDetailsError) {
              return Center(child: Text(state.message));
            }
            if (state is! ClientDetailsLoaded) return const SizedBox();

            final client = state.client;
            return RefreshIndicator(
              onRefresh: () async => _loadClient(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClientInfoHeader(client: client),
                    const SizedBox(height: 24),
                    ClientStatsCards(client: client),
                    const SizedBox(height: 24),
                    ClientActionButtons(clientId: client.id),
                    const Divider(height: 48),
                    ClientDetailsTabs(client: client),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
