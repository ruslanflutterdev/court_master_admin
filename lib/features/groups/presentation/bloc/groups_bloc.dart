import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/groups_repository.dart';
import 'groups_event.dart';
import 'groups_state.dart';

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
