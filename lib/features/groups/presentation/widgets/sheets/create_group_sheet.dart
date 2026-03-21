import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/primary_button.dart';
import '../../bloc/groups_bloc.dart';
import '../../bloc/groups_event.dart';
import 'group_basic_info_inputs.dart';
import 'group_coach_selector.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({super.key});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _maxStudentsCtrl = TextEditingController();
  final _minAgeCtrl = TextEditingController();
  final _maxAgeCtrl = TextEditingController();

  String _selectedLevel = 'Новичок';
  String? _selectedCoachId;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _maxStudentsCtrl.dispose();
    _minAgeCtrl.dispose();
    _maxAgeCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCoachId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите тренера!')));
      return;
    }

    final groupData = {
      'name': _nameCtrl.text.trim(),
      'maxStudents': int.tryParse(_maxStudentsCtrl.text) ?? 4,
      'minAge': int.tryParse(_minAgeCtrl.text) ?? 5,
      'maxAge': int.tryParse(_maxAgeCtrl.text) ?? 99,
      'skillLevel': _selectedLevel,
      'scheduleText': 'По расписанию',
      'coachId': _selectedCoachId,
    };

    context.read<GroupsBloc>().add(CreateGroupEvent(groupData));
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
              const Row(
                children: [
                  Icon(Icons.group_add, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Новая группа',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(height: 32),

              GroupBasicInfoInputs(
                nameCtrl: _nameCtrl,
                maxStudentsCtrl: _maxStudentsCtrl,
                minAgeCtrl: _minAgeCtrl,
                maxAgeCtrl: _maxAgeCtrl,
                selectedLevel: _selectedLevel,
                onLevelChanged: (val) =>
                    setState(() => _selectedLevel = val ?? 'Новичок'),
              ),

              const SizedBox(height: 24),

              GroupCoachSelector(
                selectedCoachId: _selectedCoachId,
                onChanged: (val) => setState(() => _selectedCoachId = val),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: 'Создать группу',
                color: Colors.green,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
