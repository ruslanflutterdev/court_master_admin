import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../../../../core/presentation/widgets/custom_dropdown.dart';

class EmployeeRoleInputs extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String?> onRoleChanged;
  final TextEditingController qualCtrl;
  final TextEditingController specCtrl;

  const EmployeeRoleInputs({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
    required this.qualCtrl,
    required this.specCtrl,
  });

  List<String> _getAvailableRoles(String currentUserRole) {
    final roles = <String>[];
    if (currentUserRole == AppRoles.superAdmin) roles.add(AppRoles.headAdmin);
    if ([AppRoles.superAdmin, AppRoles.headAdmin].contains(currentUserRole)) {
      roles.addAll([AppRoles.admin, AppRoles.coach]);
    }
    return roles;
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case AppRoles.headAdmin:
        return 'Главный администратор (HEAD_ADMIN)';
      case AppRoles.admin:
        return 'Администратор (ADMIN)';
      case AppRoles.coach:
        return 'Тренер (COACH)';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final currentUserRole = authState is AuthAuthenticated
        ? authState.user.role
        : AppRoles.admin;

    final availableRoles = _getAvailableRoles(currentUserRole);

    if (availableRoles.isEmpty) {
      return const Text(
        'Нет прав для добавления сотрудников',
        style: TextStyle(color: Colors.red),
      );
    }

    final isRoleValid = availableRoles.contains(selectedRole);
    if (!isRoleValid && availableRoles.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => onRoleChanged(availableRoles.first),
      );
    }

    final safeRole = isRoleValid ? selectedRole : availableRoles.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomDropdown<String>(
          value: safeRole,
          items: availableRoles,
          onChanged: onRoleChanged,
          itemLabelBuilder: _getRoleLabel,
          label: 'Роль',
        ),

        if (safeRole == AppRoles.coach) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: qualCtrl,
            decoration: const InputDecoration(
              labelText: 'Квалификация',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: specCtrl,
            decoration: const InputDecoration(
              labelText: 'Специализация',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ],
    );
  }
}
