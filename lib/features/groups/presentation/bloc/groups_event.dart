abstract class GroupsEvent {}

class LoadGroupsEvent extends GroupsEvent {}

class CreateGroupEvent extends GroupsEvent {
  final Map<String, dynamic> groupData;

  CreateGroupEvent(this.groupData);
}
