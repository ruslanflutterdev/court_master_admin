import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/group_details_bloc.dart';
import '../bloc/group_details_event.dart';
import '../widgets/group_details/group_details_body.dart';
import '../widgets/group_details/add_student_fab.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<GroupDetailsBloc>()..add(LoadGroupDetails(groupId)),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Профиль группы')),
            floatingActionButton: AddStudentFab(groupId: groupId),
            body: const GroupDetailsBody(),
          );
        },
      ),
    );
  }
}
