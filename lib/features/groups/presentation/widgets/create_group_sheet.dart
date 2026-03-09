import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/groups_bloc.dart';
import '../../../employees/presentation/bloc/employees_bloc.dart';
import '../../../../core/di/dependencies_container.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({super.key});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scheduleController = TextEditingController();
  String? _selectedCoachId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeesBloc>()..add(LoadCoachesEvent()),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Новая группа',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Название группы',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _scheduleController,
                decoration: const InputDecoration(
                  labelText: 'Расписание (напр. Пн, Ср 15:00)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  if (state is EmployeesLoading) {
                    return const CircularProgressIndicator();
                  } else if (state is EmployeesLoaded) {
                    if (state.coaches.isEmpty) {
                      return const Text('Сначала добавьте тренеров!');
                    }

                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Выберите тренера',
                        border: OutlineInputBorder(),
                      ),
                      initialValue: _selectedCoachId,
                      items: state.coaches.map((coach) {
                        return DropdownMenuItem(
                          value: coach.id,
                          child: Text('${coach.firstName} ${coach.lastName}'),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedCoachId = val),
                      validator: (value) =>
                          value == null ? 'Выберите тренера' : null,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<GroupsBloc>().add(
                      CreateGroupEvent(
                        name: _nameController.text,
                        scheduleText: _scheduleController.text,
                        coachId: _selectedCoachId!,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Создать', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
