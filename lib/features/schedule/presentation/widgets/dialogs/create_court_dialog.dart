import 'package:flutter/material.dart';

class CreateCourtDialog extends StatefulWidget {
  final String? initialName;
  final Function(String) onSave;

  const CreateCourtDialog({super.key, this.initialName, required this.onSave});

  @override
  State<CreateCourtDialog> createState() => _CreateCourtDialogState();
}

class _CreateCourtDialogState extends State<CreateCourtDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialName != null;

    return AlertDialog(
      title: Text(isEditing ? 'Редактировать корт' : 'Новый корт'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Название корта (напр. Корт 2)',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.trim().isNotEmpty) {
              widget.onSave(_nameController.text.trim());
              Navigator.pop(context);
            }
          },
          child: Text(isEditing ? 'Сохранить' : 'Создать'),
        ),
      ],
    );
  }
}
