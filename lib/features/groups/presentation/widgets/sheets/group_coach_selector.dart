import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependencies_container.dart';
import '../../../../employees/presentation/bloc/employees_bloc.dart';
import '../../../../employees/presentation/bloc/employees_event.dart';
import '../../../../employees/presentation/bloc/employees_state.dart';

class GroupCoachSelector extends StatefulWidget {
  final String? selectedCoachId;
  final ValueChanged<String?> onChanged;

  const GroupCoachSelector({
    super.key,
    required this.selectedCoachId,
    required this.onChanged,
  });

  @override
  State<GroupCoachSelector> createState() => _GroupCoachSelectorState();
}

class _GroupCoachSelectorState extends State<GroupCoachSelector> {
  late final EmployeesBloc _employeesBloc;

  @override
  void initState() {
    super.initState();
    _employeesBloc = sl<EmployeesBloc>()..add(LoadEmployeesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Тренер группы',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        BlocBuilder<EmployeesBloc, EmployeesState>(
          bloc: _employeesBloc,
          builder: (context, state) {
            if (state is EmployeesLoaded) {
              final coachesList = state.coaches
                  .where((e) => e.role == 'COACH')
                  .toList();

              return DropdownButtonFormField<String>(
                initialValue: widget.selectedCoachId,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.sports_tennis),
                ),
                items: coachesList.map((coach) {
                  return DropdownMenuItem<String>(
                    value: coach.id,
                    child: Text('${coach.firstName} ${coach.lastName}'),
                  );
                }).toList(),
                onChanged: widget.onChanged,
                validator: (val) => val == null ? 'Выберите тренера' : null,
              );
            }
            if (state is EmployeesError) {
              return const Text(
                'Ошибка загрузки',
                style: TextStyle(color: Colors.red),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
