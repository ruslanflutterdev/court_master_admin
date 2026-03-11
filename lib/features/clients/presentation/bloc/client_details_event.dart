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
