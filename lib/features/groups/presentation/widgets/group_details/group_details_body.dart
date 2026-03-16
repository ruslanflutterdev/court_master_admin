import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../groups/presentation/bloc/group_details_bloc.dart';
import '../../../../groups/presentation/bloc/group_details_state.dart';
import 'group_details_header.dart';
import 'group_students_list.dart';

class GroupDetailsBody extends StatelessWidget {
  const GroupDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
      builder: (context, state) {
        if (state is GroupDetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GroupDetailsError) {
          return Center(
            child: Text(
              'Ошибка: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is GroupDetailsLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupDetailsHeader(group: state.group),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Состав группы:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GroupStudentsList(students: state.group.students ?? []),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
