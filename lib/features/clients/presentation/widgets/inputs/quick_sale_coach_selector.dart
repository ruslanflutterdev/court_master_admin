import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependencies_container.dart';
import '../../../../employees/presentation/bloc/employees_bloc.dart';
import '../../../../employees/presentation/bloc/employees_event.dart';
import '../../../../employees/presentation/bloc/employees_state.dart';

class QuickSaleCoachSelector extends StatefulWidget {
  final String? selectedCoachId;
  final ValueChanged<String?> onChanged;

  const QuickSaleCoachSelector({
    super.key,
    required this.selectedCoachId,
    required this.onChanged,
  });

  @override
  State<QuickSaleCoachSelector> createState() => _QuickSaleCoachSelectorState();
}

class _QuickSaleCoachSelectorState extends State<QuickSaleCoachSelector> {
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
          'Исполнитель (Тренер)',
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
                'Ошибка загрузки тренеров',
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
