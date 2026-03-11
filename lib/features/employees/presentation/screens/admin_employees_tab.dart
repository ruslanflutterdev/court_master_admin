import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/employees_bloc.dart';
import '../bloc/employees_event.dart';
import '../bloc/employees_state.dart';
import '../widgets/cards/employee_list_card.dart';

class AdminEmployeesTab extends StatelessWidget {
  const AdminEmployeesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeesBloc>()..add(LoadEmployeesEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Сотрудники клуба')),
        body: BlocBuilder<EmployeesBloc, EmployeesState>(
          builder: (context, state) {
            if (state is EmployeesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is EmployeesError) {
              return Center(
                child: Text(
                  'Ошибка: ${state.message}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            if (state is EmployeesLoaded) {
              if (state.coaches.isEmpty) {
                return const Center(child: Text('Нет добавленных тренеров.'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.coaches.length,
                itemBuilder: (context, index) {
                  return EmployeeListCard(
                    coach: state.coaches[index],
                    onTap: () {
                      // Позже здесь будет переход на профиль тренера
                    },
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
