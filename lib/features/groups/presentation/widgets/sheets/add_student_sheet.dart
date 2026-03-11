import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/group_details_bloc.dart';
import '../../../data/models/student_model.dart';
import '../../../data/repositories/students_repository.dart';
import '../../../../../core/di/dependencies_container.dart';
import '../../bloc/group_details_event.dart';

class AddStudentSheet extends StatefulWidget {
  final String groupId;
  const AddStudentSheet({super.key, required this.groupId});

  @override
  State<AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<AddStudentSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedStudentId;
  List<StudentModel> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    try {
      final students = await sl<StudentsRepository>().getStudents();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              'Добавить ученика',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (_isLoading)
              const CircularProgressIndicator()
            else if (_students.isEmpty)
              const Text('В клубе пока нет свободных учеников')
            else
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Выберите ученика',
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedStudentId,
                items: _students.map((student) {
                  return DropdownMenuItem(
                    value: student.id,
                    child: Text('${student.firstName} ${student.lastName}'),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedStudentId = val),
                validator: (value) =>
                    value == null ? 'Обязательное поле' : null,
              ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<GroupDetailsBloc>().add(
                    AddStudentEvent(widget.groupId, _selectedStudentId!),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'Добавить в группу',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
