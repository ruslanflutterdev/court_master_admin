import '../../data/models/waitlist_model.dart';

abstract class WaitlistState {}

class WaitlistInitial extends WaitlistState {}

class WaitlistLoading extends WaitlistState {}

class WaitlistLoaded extends WaitlistState {
  final List<WaitlistModel> waitlist;
  final DateTime date;

  WaitlistLoaded({required this.waitlist, required this.date});
}

class WaitlistError extends WaitlistState {
  final String message;
  WaitlistError(this.message);
}
