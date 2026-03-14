abstract class WaitlistEvent {}

class LoadWaitlist extends WaitlistEvent {
  final DateTime date;
  LoadWaitlist(this.date);
}

class AddToWaitlist extends WaitlistEvent {
  final Map<String, dynamic> data;
  final DateTime date;
  AddToWaitlist(this.data, this.date);
}

class RemoveFromWaitlist extends WaitlistEvent {
  final String id;
  final DateTime date;
  RemoveFromWaitlist(this.id, this.date);
}
