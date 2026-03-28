import 'package:flutter_bloc/flutter_bloc.dart';
import 'waitlist_event.dart';
import 'waitlist_state.dart';
import '../../data/repositories/schedule_repository.dart';

class WaitlistBloc extends Bloc<WaitlistEvent, WaitlistState> {
  final ScheduleRepository repository;

  WaitlistBloc({required this.repository}) : super(WaitlistInitial()) {
    on<LoadWaitlist>((event, emit) async {
      emit(WaitlistLoading());
      try {
        final results = await Future.wait([
          repository.getWaitlists(type: 'RENTAL', date: event.date),
          repository.getWaitlists(type: 'GROUP'),
        ]);

        emit(
          WaitlistLoaded(
            rentalWaitlist: results[0],
            groupWaitlist: results[1],
            date: event.date,
          ),
        );
      } catch (e) {
        emit(WaitlistError(e.toString()));
      }
    });

    on<AddToWaitlist>((event, emit) async {
      await repository.addToWaitlist(event.data);
      add(LoadWaitlist(event.date));
    });

    on<RemoveFromWaitlist>((event, emit) async {
      await repository.removeFromWaitlist(event.id);
      add(LoadWaitlist(event.date));
    });
  }
}
