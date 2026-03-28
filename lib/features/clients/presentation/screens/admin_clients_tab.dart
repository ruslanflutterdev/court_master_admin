import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/clients_bloc.dart';
import '../bloc/clients_event.dart';
import '../bloc/clients_state.dart';
import '../widgets/search/client_list_view.dart';
import '../widgets/search/client_search_header.dart';

class AdminClientsTab extends StatefulWidget {
  const AdminClientsTab({super.key});

  @override
  State<AdminClientsTab> createState() => _AdminClientsTabState();
}

class _AdminClientsTabState extends State<AdminClientsTab> {
  ClientSegment _selectedSegment = ClientSegment.all;

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  void _loadClients() {
    context.read<ClientsBloc>().add(LoadClientsEvent());
  }

  void _onSearch(String query) {
    context.read<ClientsBloc>().add(SearchClientsEvent(query));
  }

  void _onSegmentChanged(ClientSegment segment) {
    setState(() => _selectedSegment = segment);
    context.read<ClientsBloc>().add(FilterClientsBySegmentEvent(segment));
  }

  void _onClientTap(String id) {
    context.push('/client-details/$id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClientSearchHeader(
            onSearchChanged: _onSearch,
            selectedSegment: _selectedSegment,
            onSegmentChanged: _onSegmentChanged,
          ),
          Expanded(
            child: BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                if (state is ClientsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ClientsLoaded) {
                  return ClientListView(
                    clients: state.paginatedClients,
                    currentSegment: state.currentSegment,
                    onClientTap: _onClientTap,
                  );
                }
                if (state is ClientsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
