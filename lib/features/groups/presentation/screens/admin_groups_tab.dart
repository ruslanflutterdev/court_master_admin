import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups_bloc.dart';
import '../widgets/create_group_sheet.dart';
import '../../../../core/di/dependencies_container.dart';
import 'package:go_router/go_router.dart';

class AdminGroupsTab extends StatelessWidget {
  const AdminGroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GroupsBloc>()..add(LoadGroupsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Управление группами')),
        body: BlocBuilder<GroupsBloc, GroupsState>(
          builder: (context, state) {
            if (state is GroupsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupsError) {
              return Center(
                child: Text(
                  'Ошибка: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is GroupsLoaded) {
              if (state.groups.isEmpty) {
                return const Center(
                  child: Text('Групп пока нет. Нажмите + чтобы создать.'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.groups.length,
                itemBuilder: (context, index) {
                  final group = state.groups[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        group.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Тренер: ${group.coachName}'),
                          Text('Расписание: ${group.scheduleText ?? "Не указано"}'),
                          Text(
                            'Учеников: ${group.studentsCount}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final bloc = context.read<GroupsBloc>();
                        await context.push('/group-details/${group.id}');
                        bloc.add(LoadGroupsEvent());
                      },
                    ),
                  );
                },
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
                    value: ctx.read<GroupsBloc>(),
                    child: const CreateGroupSheet(),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}