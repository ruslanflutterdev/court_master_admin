import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/clients_repository.dart';
import 'clients_event.dart';
import 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final ClientsRepository repository;

  ClientsBloc({required this.repository}) : super(ClientsLoading()) {
    on<LoadClientsEvent>((event, emit) async {
      emit(ClientsLoading());
      try {
        final clientsList = await repository.getClients();
        // При первой загрузке отдаем чистый ClientsLoaded, он сам прокинет clients в filteredClients
        emit(ClientsLoaded(clientsList));
      } catch (e) {
        emit(ClientsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<QuickSaleRequested>((event, emit) async {
      try {
        await repository.quickSale(event.saleData);
        add(LoadClientsEvent());
      } catch (e) {
        emit(ClientsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<SearchClientsEvent>((event, emit) {
      if (state is ClientsLoaded) {
        final st = state as ClientsLoaded;
        final newFiltered = _applyFiltersAndSearch(st.clients, event.query, st.currentSegment);
        emit(st.copyWith(filteredClients: newFiltered, searchQuery: event.query, currentPage: 1));
      }
    });

    on<FilterClientsBySegmentEvent>((event, emit) {
      if (state is ClientsLoaded) {
        final st = state as ClientsLoaded;
        final newFiltered = _applyFiltersAndSearch(st.clients, st.searchQuery, event.segment);
        emit(st.copyWith(filteredClients: newFiltered, currentSegment: event.segment, currentPage: 1));
      }
    });

    on<ChangePageEvent>((event, emit) {
      if (state is ClientsLoaded) {
        emit((state as ClientsLoaded).copyWith(currentPage: event.page));
      }
    });

    on<ChangeItemsPerPageEvent>((event, emit) {
      if (state is ClientsLoaded) {
        emit((state as ClientsLoaded).copyWith(itemsPerPage: event.itemsPerPage, currentPage: 1));
      }
    });
  }

  List<ClientModel> _applyFiltersAndSearch(List<ClientModel> all, String query, ClientSegment segment) {
    return all.where((c) {
      bool segmentMatch = true;
      if (segment == ClientSegment.debtors) {
        segmentMatch = c.balance < 0;
      } else if (segment == ClientSegment.deposit) {
        segmentMatch = c.balance > 0;
      } else if (segment == ClientSegment.sub) {
        segmentMatch = (c.activeSubscriptionsCount ?? 0) > 0;
      } else if (segment == ClientSegment.rent) {
        segmentMatch = c.tags.any((tag) => tag.toLowerCase() == 'аренда');
      }

      bool searchMatch = true;
      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        final fullName = '${c.firstName} ${c.lastName}'.toLowerCase();
        searchMatch = fullName.contains(lowerQuery) ||
            (c.phone ?? '').toLowerCase().contains(lowerQuery) ||
            (c.email ?? '').toLowerCase().contains(lowerQuery);
      }

      return segmentMatch && searchMatch;
    }).toList();
  }
}