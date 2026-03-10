import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart';
import '../../data/repositories/clients_repository.dart';

// --- События ---
abstract class ClientDetailsEvent {}

class LoadClientDetails extends ClientDetailsEvent {
  final String clientId;
  LoadClientDetails(this.clientId);
}

class AddPaymentEvent extends ClientDetailsEvent {
  final String clientId;
  final Map<String, dynamic> paymentData;
  AddPaymentEvent(this.clientId, this.paymentData);
}

class AddSubscriptionEvent extends ClientDetailsEvent {
  final String clientId;
  final Map<String, dynamic> subData;
  AddSubscriptionEvent(this.clientId, this.subData);
}

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

class ClientDetailsBloc extends Bloc<ClientDetailsEvent, ClientDetailsState> {
  final ClientsRepository repository;

  ClientDetailsBloc({required this.repository})
    : super(ClientDetailsLoading()) {
    on<LoadClientDetails>((event, emit) async {
      emit(ClientDetailsLoading());
      try {
        final client = await repository.getClientDetails(event.clientId);
        emit(ClientDetailsLoaded(client));
      } catch (e) {
        emit(ClientDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AddPaymentEvent>((event, emit) async {
      try {
        await repository.addPayment(event.clientId, event.paymentData);
        add(LoadClientDetails(event.clientId));
      } catch (e) {
        emit(ClientDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AddSubscriptionEvent>((event, emit) async {
      try {
        await repository.addSubscription(event.clientId, event.subData);
        add(LoadClientDetails(event.clientId));
      } catch (e) {
        emit(ClientDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
