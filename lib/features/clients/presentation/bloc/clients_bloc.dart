import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/clients_repository.dart';
import 'clients_event.dart';
import 'clients_state.dart';
import 'mixins/clients_filter_mixin.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState>
    with ClientsFilterMixin {
  final ClientsRepository repository;

  ClientsBloc({required this.repository}) : super(ClientsLoading()) {
    on<LoadClientsEvent>((event, emit) async {
      emit(ClientsLoading());
      try {
        final clientsList = await repository.getClients();
        final sortedList = applyFiltersAndSearch(
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
        final newFiltered = applyFiltersAndSearch(
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
        final newFiltered = applyFiltersAndSearch(
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
        final newFiltered = applyFiltersAndSearch(
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
        final newFiltered = applyFiltersAndSearch(
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
        final newFiltered = applyFiltersAndSearch(
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
}
