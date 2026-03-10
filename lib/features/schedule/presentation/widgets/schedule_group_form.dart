import 'package:flutter/material.dart';
import '../../../groups/data/models/group_model.dart';

class ScheduleGroupForm extends StatelessWidget {
  final List<GroupModel> groups;
  final String? selectedGroupId;
  final Function(String?) onGroupSelected;

  const ScheduleGroupForm({
    super.key,
    required this.groups,
    required this.selectedGroupId,
    required this.onGroupSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Сначала создайте группы в разделе "Группы"',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Выберите группу',
        border: OutlineInputBorder(),
      ),
      initialValue: selectedGroupId,
      items: groups.map((group) {
        return DropdownMenuItem(value: group.id, child: Text(group.name));
      }).toList(),
      onChanged: onGroupSelected,
      validator: (value) => value == null ? 'Обязательное поле' : null,
    );
  }
}
