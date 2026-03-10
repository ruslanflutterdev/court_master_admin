import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/coach_model.dart';
import '../../data/repositories/employees_repository.dart';

abstract class EmployeesEvent {}

class LoadCoachesEvent extends EmployeesEvent {}

abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<CoachModel> coaches;
  EmployeesLoaded(this.coaches);
}

class EmployeesError extends EmployeesState {
  final String message;
  EmployeesError(this.message);
}

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository repository;

  EmployeesBloc({required this.repository}) : super(EmployeesInitial()) {
    on<LoadCoachesEvent>((event, emit) async {
      emit(EmployeesLoading());
      try {
        final coaches = await repository.getCoaches();
        emit(EmployeesLoaded(coaches));
      } catch (e) {
        emit(EmployeesError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
