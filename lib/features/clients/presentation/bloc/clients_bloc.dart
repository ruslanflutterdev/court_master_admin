import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/clients_repository.dart';

abstract class ClientsEvent {}

class LoadClientsEvent extends ClientsEvent {}

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

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  final ClientsRepository repository;

  ClientsBloc({required this.repository}) : super(ClientsLoading()) {
    on<LoadClientsEvent>((event, emit) async {
      emit(ClientsLoading());
      try {
        final clients = await repository.getClients();
        emit(ClientsLoaded(clients));
      } catch (e) {
        emit(ClientsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
