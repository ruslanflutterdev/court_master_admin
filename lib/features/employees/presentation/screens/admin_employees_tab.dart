import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employees_bloc.dart';
import '../bloc/employees_state.dart';
import '../widgets/cards/employee_list_card.dart';
import '../screens/admin_coach_profile_screen.dart';
import '../widgets/sheets/create_employee_sheet.dart';

class AdminEmployeesTab extends StatelessWidget {
  const AdminEmployeesTab({super.key});

  void _showCreateEmployeeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => BlocProvider.value(
        value: context.read<EmployeesBloc>(),
        child: const CreateEmployeeSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () => _showCreateEmployeeSheet(context),
        label: const Text('Добавить тренера'),
        icon: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeesLoaded) {
            final coaches = state.coaches;

            if (coaches.isEmpty) {
              return const Center(
                child: Text(
                  'Нет добавленных тренеров.\nНажмите "+", чтобы добавить.',
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: coaches.length,
              itemBuilder: (context, index) {
                final coach = coaches[index];
                return EmployeeListCard(
                  coach: coach,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AdminCoachProfileScreen(coach: coach),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is EmployeesError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
