abstract class ClientsEvent {}

class LoadClientsEvent extends ClientsEvent {}

class QuickSaleRequested extends ClientsEvent {
  final Map<String, dynamic> saleData;
  QuickSaleRequested(this.saleData);
}
