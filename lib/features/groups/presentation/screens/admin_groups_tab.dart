import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/groups_bloc.dart';
import '../bloc/groups_event.dart';
import '../bloc/groups_state.dart';
import '../widgets/cards/group_list_card.dart';
import '../widgets/sheets/create_group_sheet.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminGroupsTab extends StatelessWidget {
  const AdminGroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<GroupsBloc>()..add(LoadGroupsEvent()),
      child: Builder(
        builder: (innerContext) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Группы'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => showModalBottomSheet(
                    context: innerContext,
                    isScrollControlled: true,
                    builder: (_) => BlocProvider.value(
                      value: innerContext.read<GroupsBloc>(),
                      child: const CreateGroupSheet(),
                    ),
                  ),
                ),
              ],
            ),
            body: BlocBuilder<GroupsBloc, GroupsState>(
              builder: (context, state) {
                if (state is GroupsLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is GroupsError)
                  return Center(
                    child: Text(
                      'Ошибка: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                if (state is GroupsLoaded) {
                  if (state.groups.isEmpty)
                    return const Center(child: Text('Нет созданных групп'));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.groups.length,
                    itemBuilder: (context, index) {
                      final group = state.groups[index];
                      return GroupListCard(
                        group: group,
                        onTap: () async {
                          final bloc = innerContext.read<GroupsBloc>();
                          await innerContext.push('/group-details/${group.id}');
                          bloc.add(LoadGroupsEvent());
                        },
                      );
                    },
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
