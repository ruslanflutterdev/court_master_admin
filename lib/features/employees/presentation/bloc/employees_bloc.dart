import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/employees_repository.dart';
import 'employees_event.dart';
import 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository repository;

  EmployeesBloc({required this.repository}) : super(EmployeesLoading()) {
    on<LoadEmployeesEvent>((event, emit) async {
      emit(EmployeesLoading());
      try {
        final coaches = await repository.getCoaches();
        emit(EmployeesLoaded(coaches));
      } catch (e) {
        emit(EmployeesError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AddCoachRequested>((event, emit) async {
      try {
        await repository.createCoach(event.coachData);
        add(LoadEmployeesEvent());
      } catch (e) {
        emit(EmployeesError(e.toString()));
      }
    });
  }
}
