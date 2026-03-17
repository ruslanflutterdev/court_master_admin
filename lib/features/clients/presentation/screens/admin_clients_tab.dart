import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/clients_bloc.dart';
import '../bloc/clients_event.dart';
import '../bloc/clients_state.dart';
import '../widgets/cards/client_list_card.dart';
import '../widgets/search/client_filters_row.dart';
import '../widgets/search/client_search_bar.dart';
import '../widgets/search/client_segments_bar.dart';
import '../widgets/search/client_pagination_footer.dart';

class AdminClientsTab extends StatelessWidget {
  const AdminClientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Клиенты и Финансы'),
      ),
      body: BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) {
          if (state is ClientsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClientsError) {
            return Center(child: Text('Ошибка: ${state.message}', style: const TextStyle(color: Colors.red)));
          }
          if (state is ClientsLoaded) {
            final paginatedList = state.paginatedClients;

            return Column(
              children: [
                ClientSearchBar(
                  onChanged: (query) => context.read<ClientsBloc>().add(SearchClientsEvent(query)),
                ),

                ClientSegmentsBar(
                  selectedSegment: state.currentSegment,
                  onSegmentChanged: (segment) => context.read<ClientsBloc>().add(FilterClientsBySegmentEvent(segment)),
                ),

                const ClientFiltersRow(),

                Expanded(
                  child: state.filteredClients.isEmpty
                      ? const Center(child: Text('Клиентов не найдено.'))
                      : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: paginatedList.length,
                    itemBuilder: (context, index) {
                      final client = paginatedList[index];
                      return ClientListCard(
                        client: client,
                        onTap: () async {
                          final bloc = context.read<ClientsBloc>();
                          await context.push('/client-details/${client.id}');
                          bloc.add(LoadClientsEvent());
                        },
                      );
                    },
                  ),
                ),

                ClientPaginationFooter(
                  currentPage: state.currentPage,
                  totalPages: state.totalPages,
                  itemsPerPage: state.itemsPerPage,
                  onPageChanged: (page) => context.read<ClientsBloc>().add(ChangePageEvent(page)),
                  onItemsPerPageChanged: (items) => context.read<ClientsBloc>().add(ChangeItemsPerPageEvent(items)),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}