import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/group_model.dart';
import '../../data/repositories/groups_repository.dart';

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

abstract class GroupsState {}

class GroupsInitial extends GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<GroupModel> groups;
  GroupsLoaded(this.groups);
}

class GroupsError extends GroupsState {
  final String message;
  GroupsError(this.message);
}

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupsRepository repository;

  GroupsBloc({required this.repository}) : super(GroupsInitial()) {
    on<LoadGroupsEvent>((event, emit) async {
      emit(GroupsLoading());
      try {
        final groups = await repository.getGroups();
        emit(GroupsLoaded(groups));
      } catch (e) {
        emit(GroupsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<CreateGroupEvent>((event, emit) async {
      try {
        await repository.createGroup(
          event.name,
          event.scheduleText,
          event.coachId,
        );
        add(LoadGroupsEvent());
      } catch (e) {
        emit(GroupsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
