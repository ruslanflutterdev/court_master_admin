import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/group_model.dart';
import '../../data/repositories/groups_repository.dart';

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

abstract class GroupDetailsState {}

class GroupDetailsLoading extends GroupDetailsState {}

class GroupDetailsLoaded extends GroupDetailsState {
  final GroupModel group;
  GroupDetailsLoaded(this.group);
}

class GroupDetailsError extends GroupDetailsState {
  final String message;
  GroupDetailsError(this.message);
}

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
