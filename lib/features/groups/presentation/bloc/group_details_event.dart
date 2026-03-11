abstract class GroupDetailsEvent {}

class LoadGroupDetails extends GroupDetailsEvent {
  final String groupId;
  LoadGroupDetails(this.groupId);
}

class AddStudentEvent extends GroupDetailsEvent {
  final String groupId;
  final String studentId;
  AddStudentEvent(this.groupId, this.studentId);
}
