abstract class GroupsEvent {}

class LoadGroupsEvent extends GroupsEvent {}

class CreateGroupEvent extends GroupsEvent {
  final String name;
  final String scheduleText;
  final String coachId;

  CreateGroupEvent({
    required this.name,
    required this.scheduleText,
    required this.coachId,
  });
}
