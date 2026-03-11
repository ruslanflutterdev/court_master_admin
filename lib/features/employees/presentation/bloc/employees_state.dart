import '../../data/models/coach_model.dart';

abstract class EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<CoachModel> coaches;
  EmployeesLoaded(this.coaches);
}

class EmployeesError extends EmployeesState {
  final String message;
  EmployeesError(this.message);
}
