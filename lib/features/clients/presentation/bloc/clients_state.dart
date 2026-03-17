import '../../data/models/client_model.dart';

enum ClientSegment { all, debtors, sub, rent, deposit }

abstract class ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<ClientModel> clients;
  final List<ClientModel> filteredClients;
  final String searchQuery;
  final ClientSegment currentSegment;
  final int currentPage;
  final int itemsPerPage;

  ClientsLoaded(
    this.clients, {
    List<ClientModel>? filteredClients,
    this.searchQuery = '',
    this.currentSegment = ClientSegment.all,
    this.currentPage = 1,
    this.itemsPerPage = 20,
  }) : filteredClients = filteredClients ?? clients;

  int get totalPages => filteredClients.isEmpty
      ? 1
      : (filteredClients.length / itemsPerPage).ceil();

  List<ClientModel> get paginatedClients {
    final startIndex = (currentPage - 1) * itemsPerPage;
    if (startIndex >= filteredClients.length) return [];
    return filteredClients.skip(startIndex).take(itemsPerPage).toList();
  }

  ClientsLoaded copyWith({
    List<ClientModel>? clients,
    List<ClientModel>? filteredClients,
    String? searchQuery,
    ClientSegment? currentSegment,
    int? currentPage,
    int? itemsPerPage,
  }) {
    return ClientsLoaded(
      clients ?? this.clients,
      filteredClients: filteredClients ?? this.filteredClients,
      searchQuery: searchQuery ?? this.searchQuery,
      currentSegment: currentSegment ?? this.currentSegment,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}

class ClientsError extends ClientsState {
  final String message;
  ClientsError(this.message);
}
