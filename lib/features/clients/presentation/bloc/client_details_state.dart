import '../../data/models/client_model.dart';

abstract class ClientDetailsState {}

class ClientDetailsLoading extends ClientDetailsState {}

class ClientDetailsLoaded extends ClientDetailsState {
  final ClientModel client;
  ClientDetailsLoaded(this.client);
}

class ClientDetailsError extends ClientDetailsState {
  final String message;
  ClientDetailsError(this.message);
}
