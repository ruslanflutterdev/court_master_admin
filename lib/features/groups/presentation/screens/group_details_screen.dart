import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/group_details_bloc.dart';
import '../widgets/add_student_sheet.dart';
import '../../../../core/di/dependencies_container.dart';

class GroupDetailsScreen extends StatelessWidget {
  final String groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GroupDetailsBloc>()..add(LoadGroupDetails(groupId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Детали группы')),
        body: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
          builder: (context, state) {
            if (state is GroupDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupDetailsError) {
              return Center(child: Text('Ошибка: ${state.message}', style: const TextStyle(color: Colors.red)));
            } else if (state is GroupDetailsLoaded) {
              final group = state.group;
              final students = group.students ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 3,
                      color: Colors.green.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(group.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Text('Тренер: ${group.coachName}', style: const TextStyle(fontSize: 16)),
                            Text('Расписание: ${group.scheduleText ?? "Нет"}', style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('Список учеников:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),

                  Expanded(
                    child: students.isEmpty
                        ? const Center(child: Text('В группе пока нет учеников.'))
                        : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text('${student.firstName} ${student.lastName}'),
                            subtitle: Text(student.email),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),

        floatingActionButton: Builder(
            builder: (ctx) {
              return FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: ctx,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider.value(
                      value: ctx.read<GroupDetailsBloc>(),
                      child: AddStudentSheet(groupId: groupId),
                    ),
                  );
                },
                backgroundColor: Colors.blue,
                child: const Icon(Icons.person_add, color: Colors.white),
              );
            }
        ),
      ),
    );
  }
}