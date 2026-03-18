import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/clients_bloc.dart';
import '../../bloc/clients_event.dart';
import '../../bloc/clients_state.dart';

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
                child: _buildDropdown(
                  label: 'Уровень',
                  value: state.selectedLevel ?? 'Все',
                  items: ['Все', 'Новичок', 'Любитель', 'Профи'],
                  onChanged: (val) {
                    context.read<ClientsBloc>().add(
                      FilterByLevelEvent(val == 'Все' ? null : val),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: _buildDropdown(
                  label: 'Статус',
                  value: state.selectedTag ?? 'Все',
                  items: ['Все', 'VIP', 'Корпорат', 'Скидка'],
                  onChanged: (val) {
                    context.read<ClientsBloc>().add(
                      FilterByTagEvent(val == 'Все' ? null : val),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),

              Expanded(
                child: _buildDropdown(
                  label: 'Сортировка',
                  value: state.sortBy,
                  items: ['name', 'debt', 'spent'],
                  displayItems: {
                    'name': 'По алфавиту',
                    'debt': 'Сначала должники',
                    'spent': 'По выручке',
                  },
                  onChanged: (val) {
                    if (val != null) {
                      context.read<ClientsBloc>().add(SortClientsEvent(val));
                    }
                  },
                  isSort: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    Map<String, String>? displayItems,
    bool isSort = false,
  }) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isSort ? Colors.orange.shade50 : Colors.grey.shade50,
        border: Border.all(
          color: isSort ? Colors.orange.shade200 : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: Icon(
            Icons.arrow_drop_down,
            color: isSort ? Colors.orange : Colors.grey,
          ),
          style: const TextStyle(fontSize: 12, color: Colors.black87),
          onChanged: onChanged,
          items: items.map((String item) {
            final displayText = displayItems != null
                ? displayItems[item]!
                : item;
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                displayText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: value == item && item != 'Все' && item != 'name'
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
