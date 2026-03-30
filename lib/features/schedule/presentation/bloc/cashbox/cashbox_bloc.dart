import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/cashbox_repository.dart';
import 'cashbox_event.dart';
import 'cashbox_state.dart';

class CashboxBloc extends Bloc<CashboxEvent, CashboxState> {
  final CashboxRepository repository;

  CashboxBloc({required this.repository}) : super(CashboxInitial()) {
    on<LoadCashboxStatus>((event, emit) async {
      emit(CashboxLoading());
      try {
        final status = await repository.getShiftStatus();
        emit(CashboxLoaded(status));
      } catch (e) {
        emit(CashboxError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<OpenShiftEvent>((event, emit) async {
      emit(CashboxLoading());
      try {
        await repository.openShift();
        add(LoadCashboxStatus());
      } catch (e) {
        emit(CashboxError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<CloseShiftEvent>((event, emit) async {
      emit(CashboxLoading());
      try {
        final result = await repository.closeShift();
        emit(CashboxShiftClosed(result));
      } catch (e) {
        emit(CashboxError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
