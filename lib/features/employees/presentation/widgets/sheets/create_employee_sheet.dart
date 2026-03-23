import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/primary_button.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../bloc/employees_bloc.dart';
import '../../bloc/employees_event.dart';
import 'employee_basic_info_inputs.dart';
import 'employee_role_inputs.dart';
import 'create_employee_sheet_header.dart';

class CreateEmployeeSheet extends StatefulWidget {
  const CreateEmployeeSheet({super.key});

  @override
  State<CreateEmployeeSheet> createState() => _CreateEmployeeSheetState();
}

class _CreateEmployeeSheetState extends State<CreateEmployeeSheet> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _qualCtrl = TextEditingController();
  final _specCtrl = TextEditingController();

  String _selectedRole = AppRoles.coach;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _qualCtrl.dispose();
    _specCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'firstName': _firstNameCtrl.text.trim(),
      'lastName': _lastNameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'password': _passwordCtrl.text.trim(),
      'role': _selectedRole,
      'qualification': _selectedRole == AppRoles.coach
          ? _qualCtrl.text.trim()
          : '',
      'specialization': _selectedRole == AppRoles.coach
          ? _specCtrl.text.trim()
          : '',
    };

    context.read<EmployeesBloc>().add(AddCoachRequested(data));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CreateEmployeeSheetHeader(),
              EmployeeBasicInfoInputs(
                firstNameCtrl: _firstNameCtrl,
                lastNameCtrl: _lastNameCtrl,
                emailCtrl: _emailCtrl,
                phoneCtrl: _phoneCtrl,
                passwordCtrl: _passwordCtrl,
              ),
              const SizedBox(height: 16),
              EmployeeRoleInputs(
                selectedRole: _selectedRole,
                onRoleChanged: (val) =>
                    setState(() => _selectedRole = val ?? AppRoles.coach),
                qualCtrl: _qualCtrl,
                specCtrl: _specCtrl,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Создать сотрудника',
                color: Colors.blue,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
