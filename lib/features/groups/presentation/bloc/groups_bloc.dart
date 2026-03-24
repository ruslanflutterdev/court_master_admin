import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/groups_repository.dart';
import 'groups_event.dart';
import 'groups_state.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  final GroupsRepository repository;

  GroupsBloc({required this.repository}) : super(GroupsInitial()) {
    // 1. Загрузка групп
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
        emit(GroupsLoading());
        await repository.createGroup(event.groupData);
        final groups = await repository.getGroups();
        emit(GroupsLoaded(groups));
      } catch (e) {
        emit(GroupsError('Ошибка создания группы: $e'));
      }
    });
  }
}
