import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employees_bloc.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminEmployeesTab extends StatelessWidget {
  const AdminEmployeesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeesBloc>()..add(LoadCoachesEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Сотрудники клуба')),
        body: BlocBuilder<EmployeesBloc, EmployeesState>(
          builder: (context, state) {
            if (state is EmployeesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeesError) {
              return Center(
                child: Text(
                  'Ошибка: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is EmployeesLoaded) {
              if (state.coaches.isEmpty) {
                return const Center(child: Text('Нет добавленных тренеров.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.coaches.length,
                itemBuilder: (context, index) {
                  final coach = state.coaches[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.sports_tennis, color: Colors.white),
                      ),
                      title: Text(
                        '${coach.firstName} ${coach.lastName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(coach.email),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // Позже здесь будет переход на профиль тренера
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('Ожидание данных...'));
          },
        ),
      ),
    );
  }
}
