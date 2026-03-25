import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/clients_repository.dart';
import 'client_details_event.dart';
import 'client_details_state.dart';

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
        add(LoadClientDetails(clientId: event.clientId));
      } catch (e) {
        emit(ClientDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AddSubscriptionEvent>((event, emit) async {
      try {
        await repository.addSubscription(event.clientId, event.subData);
        add(LoadClientDetails(clientId: event.clientId));
      } catch (e) {
        emit(ClientDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<RefundTransactionEvent>((event, emit) async {
      try {
        await repository.refundTransaction(event.transactionId);
        add(LoadClientDetails(clientId: event.clientId));
      } catch (e) {
        emit(ClientDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
