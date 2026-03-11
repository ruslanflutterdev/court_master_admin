import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/clients_repository.dart';
import 'clients_event.dart';
import 'clients_state.dart';

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

    on<QuickSaleRequested>((event, emit) async {
      try {
        await repository.quickSale(event.saleData);
        add(LoadClientsEvent());
      } catch (e) {
        emit(ClientsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
