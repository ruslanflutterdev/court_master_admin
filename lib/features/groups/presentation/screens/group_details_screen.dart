import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/group_details_bloc.dart';
import '../bloc/group_details_event.dart';
import '../bloc/group_details_state.dart';
import '../widgets/sheets/add_student_sheet.dart';
import '../../../../core/di/dependencies_container.dart';

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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => showModalBottomSheet(
                context: innerContext,
                isScrollControlled: true,
                builder: (_) => BlocProvider.value(
                  value: innerContext.read<GroupDetailsBloc>(),
                  child: AddStudentSheet(groupId: groupId),
                ),
              ),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Добавить',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: BlocBuilder<GroupDetailsBloc, GroupDetailsState>(
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
                  final group = state.group;
                  final students = group.students ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Шапка группы
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        color: Colors.orange.shade50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Тренер: ${group.coach?.firstName ?? 'Не назначен'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Расписание: ${group.scheduleText}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Chip(
                              label: Text(
                                'Учеников: ${students.length}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          ],
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Состав группы:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: students.isEmpty
                            ? const Center(
                                child: Text('В группе пока нет учеников'),
                              )
                            : ListView.builder(
                                itemCount: students.length,
                                itemBuilder: (context, index) {
                                  final student = students[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue.withAlpha(
                                          51,
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      title: Text(
                                        '${student.firstName} ${student.lastName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        student.phone ?? 'Нет телефона',
                                      ),
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
          );
        },
      ),
    );
  }
}
