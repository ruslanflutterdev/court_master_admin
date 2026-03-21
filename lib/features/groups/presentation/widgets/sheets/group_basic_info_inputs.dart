import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';

class GroupBasicInfoInputs extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController maxStudentsCtrl;
  final TextEditingController minAgeCtrl;
  final TextEditingController maxAgeCtrl;
  final String selectedLevel;
  final ValueChanged<String?> onLevelChanged;

  const GroupBasicInfoInputs({
    super.key,
    required this.nameCtrl,
    required this.maxStudentsCtrl,
    required this.minAgeCtrl,
    required this.maxAgeCtrl,
    required this.selectedLevel,
    required this.onLevelChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Основная информация',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        CustomTextField(
          controller: nameCtrl,
          label: 'Название группы (например: Младшие профи)',
          prefixIcon: Icons.group,
        ),
        CustomTextField(
          controller: maxStudentsCtrl,
          label: 'Максимум учеников',
          prefixIcon: Icons.format_list_numbered,
          keyboardType: TextInputType.number,
        ),
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: minAgeCtrl,
                label: 'Мин. возраст',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.child_care,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                controller: maxAgeCtrl,
                label: 'Макс. возраст',
                keyboardType: TextInputType.number,
                prefixIcon: Icons.escalator_warning,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: selectedLevel,
          decoration: InputDecoration(
            labelText: 'Уровень подготовки',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.star_border),
          ),
          items: const [
            DropdownMenuItem(value: 'Новичок', child: Text('Новичок')),
            DropdownMenuItem(value: 'Любитель', child: Text('Любитель')),
            DropdownMenuItem(value: 'Профи', child: Text('Профи')),
          ],
          onChanged: onLevelChanged,
        ),
      ],
    );
  }
}
