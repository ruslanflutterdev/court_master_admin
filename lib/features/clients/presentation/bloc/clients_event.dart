import 'clients_state.dart';

abstract class ClientsEvent {}

class LoadClientsEvent extends ClientsEvent {}

class QuickSaleRequested extends ClientsEvent {
  final Map<String, dynamic> saleData;
  QuickSaleRequested(this.saleData);
}

class SearchClientsEvent extends ClientsEvent {
  final String query;
  SearchClientsEvent(this.query);
}

class FilterClientsBySegmentEvent extends ClientsEvent {
  final ClientSegment segment;
  FilterClientsBySegmentEvent(this.segment);
}

class ChangePageEvent extends ClientsEvent {
  final int page;
  ChangePageEvent(this.page);
}

class ChangeItemsPerPageEvent extends ClientsEvent {
  final int itemsPerPage;
  ChangeItemsPerPageEvent(this.itemsPerPage);
}