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
        final sortedList = _applyFiltersAndSearch(
          clientsList,
          '',
          ClientSegment.all,
          null,
          null,
          'name',
        );
        emit(ClientsLoaded(clientsList, filteredClients: sortedList));
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
        final newFiltered = _applyFiltersAndSearch(
          st.clients,
          event.query,
          st.currentSegment,
          st.selectedLevel,
          st.selectedTag,
          st.sortBy,
        );
        emit(
          st.copyWith(
            filteredClients: newFiltered,
            searchQuery: event.query,
            currentPage: 1,
          ),
        );
      }
    });

    on<FilterClientsBySegmentEvent>((event, emit) {
      if (state is ClientsLoaded) {
        final st = state as ClientsLoaded;
        final newFiltered = _applyFiltersAndSearch(
          st.clients,
          st.searchQuery,
          event.segment,
          st.selectedLevel,
          st.selectedTag,
          st.sortBy,
        );
        emit(
          st.copyWith(
            filteredClients: newFiltered,
            currentSegment: event.segment,
            currentPage: 1,
          ),
        );
      }
    });

    on<FilterByLevelEvent>((event, emit) {
      if (state is ClientsLoaded) {
        final st = state as ClientsLoaded;
        final newFiltered = _applyFiltersAndSearch(
          st.clients,
          st.searchQuery,
          st.currentSegment,
          event.level,
          st.selectedTag,
          st.sortBy,
        );
        emit(
          st.copyWith(
            filteredClients: newFiltered,
            selectedLevel: event.level,
            currentPage: 1,
          ),
        );
      }
    });

    on<FilterByTagEvent>((event, emit) {
      if (state is ClientsLoaded) {
        final st = state as ClientsLoaded;
        final newFiltered = _applyFiltersAndSearch(
          st.clients,
          st.searchQuery,
          st.currentSegment,
          st.selectedLevel,
          event.tag,
          st.sortBy,
        );
        emit(
          st.copyWith(
            filteredClients: newFiltered,
            selectedTag: event.tag,
            currentPage: 1,
          ),
        );
      }
    });

    on<SortClientsEvent>((event, emit) {
      if (state is ClientsLoaded) {
        final st = state as ClientsLoaded;
        final newFiltered = _applyFiltersAndSearch(
          st.clients,
          st.searchQuery,
          st.currentSegment,
          st.selectedLevel,
          st.selectedTag,
          event.sortBy,
        );
        emit(
          st.copyWith(
            filteredClients: newFiltered,
            sortBy: event.sortBy,
            currentPage: 1,
          ),
        );
      }
    });

    on<ChangePageEvent>((event, emit) {
      if (state is ClientsLoaded) {
        emit((state as ClientsLoaded).copyWith(currentPage: event.page));
      }
    });

    on<ChangeItemsPerPageEvent>((event, emit) {
      if (state is ClientsLoaded) {
        emit(
          (state as ClientsLoaded).copyWith(
            itemsPerPage: event.itemsPerPage,
            currentPage: 1,
          ),
        );
      }
    });
  }

  List<ClientModel> _applyFiltersAndSearch(
    List<ClientModel> all,
    String query,
    ClientSegment segment,
    String? level,
    String? tag,
    String sortBy,
  ) {
    final filtered = all.where((c) {
      bool segmentMatch = true;
      if (segment == ClientSegment.debtors) {
        segmentMatch = c.balance < 0;
      } else if (segment == ClientSegment.deposit) {
        segmentMatch = c.balance > 0;
      } else if (segment == ClientSegment.sub) {
        segmentMatch = (c.activeSubscriptionsCount ?? 0) > 0;
      } else if (segment == ClientSegment.rent) {
        segmentMatch =
            c.hasRent || c.tags.any((t) => t.toLowerCase() == 'аренда');
      }

      bool searchMatch = true;
      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        final fullName = '${c.firstName} ${c.lastName}'.toLowerCase();
        searchMatch =
            fullName.contains(lowerQuery) ||
            (c.phone ?? '').toLowerCase().contains(lowerQuery) ||
            (c.email ?? '').toLowerCase().contains(lowerQuery);
      }

      bool levelMatch = true;
      if (level != null && level != 'Все') {
        levelMatch = c.skillLevel == level;
      }

      bool tagMatch = true;
      if (tag != null && tag != 'Все') {
        tagMatch = c.tags.contains(tag);
      }

      return segmentMatch && searchMatch && levelMatch && tagMatch;
    }).toList();

    filtered.sort((a, b) {
      if (sortBy == 'debt') {
        return a.balance.compareTo(b.balance);
      } else if (sortBy == 'spent') {
        return b.totalSpent.compareTo(a.totalSpent);
      } else {
        int nameComp = a.firstName.compareTo(b.firstName);
        if (nameComp != 0) return nameComp;
        return (a.lastName).compareTo(b.lastName);
      }
    });

    return filtered;
  }
}
