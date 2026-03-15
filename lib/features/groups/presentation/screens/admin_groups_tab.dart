import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/groups_bloc.dart';
import '../bloc/groups_event.dart';
import '../bloc/groups_state.dart';
import '../widgets/cards/group_list_card.dart';
import '../widgets/sheets/create_group_sheet.dart';
import 'group_details_screen.dart';
// ИСПРАВЛЕНИЕ 1: Импортируем EmployeesBloc
import '../../../employees/presentation/bloc/employees_bloc.dart';

class AdminGroupsTab extends StatelessWidget {
  const AdminGroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GroupsBloc>()..add(LoadGroupsEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Группы клуба')),

        body: Builder(
          builder: (ctx) {
            return BlocBuilder<GroupsBloc, GroupsState>(
              builder: (context, state) {
                if (state is GroupsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is GroupsError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (state is GroupsLoaded) {
                  if (state.groups.isEmpty) {
                    return const Center(child: Text('Нет активных групп.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.groups.length,
                    itemBuilder: (context, index) {
                      return GroupListCard(
                        group: state.groups[index],
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GroupDetailsScreen(
                                groupId: state.groups[index].id,
                              ),
                            ),
                          );
                          if (!ctx.mounted) return;
                          ctx.read<GroupsBloc>().add(LoadGroupsEvent());
                        },
                      );
                    },
                  );
                }
                return const Center(child: Text('Ожидание данных...'));
              },
            );
          },
        ),

        floatingActionButton: Builder(
          builder: (ctx) {
            return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                  context: ctx,
                  isScrollControlled: true,
                  builder: (_) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: ctx.read<GroupsBloc>()),
                      BlocProvider(create: (_) => sl<EmployeesBloc>()),
                    ],
                    child: const CreateGroupSheet(),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
