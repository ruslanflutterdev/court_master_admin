import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/groups_repository.dart';
import 'group_details_event.dart';
import 'group_details_state.dart';

class GroupDetailsBloc extends Bloc<GroupDetailsEvent, GroupDetailsState> {
  final GroupsRepository repository;

  GroupDetailsBloc({required this.repository}) : super(GroupDetailsLoading()) {
    on<LoadGroupDetails>((event, emit) async {
      emit(GroupDetailsLoading());
      try {
        final group = await repository.getGroupDetails(event.groupId);
        emit(GroupDetailsLoaded(group));
      } catch (e) {
        emit(GroupDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<AddStudentEvent>((event, emit) async {
      try {
        await repository.addStudentToGroup(event.groupId, event.studentId);
        add(LoadGroupDetails(event.groupId));
      } catch (e) {
        emit(GroupDetailsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
