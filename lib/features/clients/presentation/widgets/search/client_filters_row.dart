import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/clients_bloc.dart';
import '../../bloc/clients_event.dart';
import '../../bloc/clients_state.dart';
import 'client_filter_dropdown.dart';

class ClientFiltersRow extends StatelessWidget {
  const ClientFiltersRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, state) {
        if (state is! ClientsLoaded) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: ClientFilterDropdown(
                  value: state.selectedLevel ?? 'Все',
                  items: const ['Все', 'Новичок', 'Любитель', 'Профи'],
                  onChanged: (val) {
                    final level = val == 'Все' ? null : val;
                    context.read<ClientsBloc>().add(FilterByLevelEvent(level));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClientFilterDropdown(
                  value: state.selectedTag ?? 'Все',
                  items: const ['Все', 'VIP', 'Корпорат', 'Скидка'],
                  onChanged: (val) {
                    final tag = val == 'Все' ? null : val;
                    context.read<ClientsBloc>().add(FilterByTagEvent(tag));
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ClientFilterDropdown(
                  value: state.sortBy,
                  items: const ['name', 'debt', 'spent'],
                  displayItems: const {
                    'name': 'По алфавиту',
                    'debt': 'Сначала должники',
                    'spent': 'По выручке',
                  },
                  isSort: true,
                  onChanged: (val) {
                    if (val != null) {
                      context.read<ClientsBloc>().add(SortClientsEvent(val));
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
