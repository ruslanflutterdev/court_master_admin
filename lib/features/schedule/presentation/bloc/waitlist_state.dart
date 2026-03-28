import '../../data/models/waitlist_model.dart';

abstract class WaitlistState {}

class WaitlistInitial extends WaitlistState {}

class WaitlistLoading extends WaitlistState {}

class WaitlistLoaded extends WaitlistState {
  final List<WaitlistModel> rentalWaitlist;
  final List<WaitlistModel> groupWaitlist;
  final DateTime date;

  WaitlistLoaded({
    required this.rentalWaitlist,
    required this.groupWaitlist,
    required this.date,
  });
}

class WaitlistError extends WaitlistState {
  final String message;
  WaitlistError(this.message);
}
