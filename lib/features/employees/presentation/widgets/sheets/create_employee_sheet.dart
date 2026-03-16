import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/employees_bloc.dart';
import '../../bloc/employees_event.dart';

class CreateEmployeeSheet extends StatefulWidget {
  const CreateEmployeeSheet({super.key});

  @override
  State<CreateEmployeeSheet> createState() => _CreateEmployeeSheetState();
}

class _CreateEmployeeSheetState extends State<CreateEmployeeSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _specializationController = TextEditingController();

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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Новый сотрудник',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Введите имя' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Фамилия',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Введите фамилию' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (логин)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@')
                    ? 'Некорректный email'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _qualificationController,
                decoration: const InputDecoration(
                  labelText: 'Квалификация',
                  border: OutlineInputBorder(),
                  hintText: 'например, Мастер спорта',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _specializationController,
                decoration: const InputDecoration(
                  labelText: 'Специализация',
                  border: OutlineInputBorder(),
                  hintText: 'например, дети 5-10 лет',
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<EmployeesBloc>().add(
                        AddCoachRequested({
                          'firstName': _firstNameController.text,
                          'lastName': _lastNameController.text,
                          'phone': _phoneController.text,
                          'email': _emailController.text,
                          'password':
                              'password123', // Временный пароль по умолчанию
                          'role': 'tennisCoach',
                          'qualification': _qualificationController.text,
                          'specialization': _specializationController.text,
                        }),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Создать сотрудника'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
