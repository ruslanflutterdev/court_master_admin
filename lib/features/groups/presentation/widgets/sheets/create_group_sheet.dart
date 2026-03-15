import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../employees/presentation/bloc/employees_bloc.dart';
import '../../../../employees/presentation/bloc/employees_event.dart';
import '../../../../employees/presentation/bloc/employees_state.dart';
import '../../bloc/groups_bloc.dart';
import '../../bloc/groups_event.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({super.key});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final nameCtrl = TextEditingController();
  String selectedLevel = 'Начинающие';
  int maxStudents = 4;
  String? selectedCoachId;

  @override
  void initState() {
    super.initState();
    context.read<EmployeesBloc>().add(LoadEmployeesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Создать новую группу',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Название группы (например: Дети 5-7 лет)',
              ),
            ),
            const SizedBox(height: 8),

            // ВЫПАДАЮЩИЙ СПИСОК С ТРЕНЕРАМИ
            BlocBuilder<EmployeesBloc, EmployeesState>(
              builder: (context, state) {
                if (state is EmployeesLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: LinearProgressIndicator(),
                  );
                }

                if (state is EmployeesLoaded) {
                  if (state.coaches.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Нет тренеров! Сначала добавьте тренера.',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (selectedCoachId == null && state.coaches.isNotEmpty) {
                    selectedCoachId = state.coaches.first.id;
                  }

                  return DropdownButtonFormField<String>(
                    initialValue: selectedCoachId,
                    decoration: const InputDecoration(
                      labelText: 'Выберите тренера',
                    ),
                    items: state.coaches.map((coach) {
                      return DropdownMenuItem(
                        value: coach.id,
                        child: Text('${coach.firstName} ${coach.lastName}'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedCoachId = val),
                  );
                }

                return const Text(
                  'Не удалось загрузить тренеров',
                  style: TextStyle(color: Colors.red),
                );
              },
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedLevel,
              decoration: const InputDecoration(
                labelText: 'Уровень подготовки',
              ),
              items: ['Начинающие', 'Средний', 'Продвинутый']
                  .map((val) => DropdownMenuItem(value: val, child: Text(val)))
                  .toList(),
              onChanged: (val) => setState(() => selectedLevel = val!),
            ),
            const SizedBox(height: 8),

            TextField(
              decoration: InputDecoration(
                labelText: 'Макс. количество учеников: $maxStudents',
              ),
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final num = int.tryParse(val);
                if (num != null) maxStudents = num;
              },
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                if (nameCtrl.text.isEmpty || selectedCoachId == null) return;

                context.read<GroupsBloc>().add(
                  CreateGroupEvent(
                    name: nameCtrl.text,
                    coachId: selectedCoachId!,
                    scheduleText: 'Расписание не задано',
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text('Создать группу'),
            ),
          ],
        ),
      ),
    );
  }
}
