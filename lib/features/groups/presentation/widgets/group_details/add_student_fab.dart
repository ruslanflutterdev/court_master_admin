import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../groups/presentation/bloc/group_details_bloc.dart';
import '../../../../groups/presentation/widgets/sheets/add_student_sheet.dart';

class AddStudentFab extends StatelessWidget {
  final String groupId;

  const AddStudentFab({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: null,
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.person_add, color: Colors.white),
      label: const Text('Добавить', style: TextStyle(color: Colors.white)),
      onPressed: () {
        final bloc = context.read<GroupDetailsBloc>();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: AddStudentSheet(groupId: groupId),
          ),
        );
      },
    );
  }
}
