import '../../data/models/client_model.dart';

abstract class ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<ClientModel> clients;
  ClientsLoaded(this.clients);
}

class ClientsError extends ClientsState {
  final String message;
  ClientsError(this.message);
}
