abstract class EmployeesEvent {}

class LoadEmployeesEvent extends EmployeesEvent {}

class AddCoachRequested extends EmployeesEvent {
  final Map<String, dynamic> coachData;
  AddCoachRequested(this.coachData);
}
