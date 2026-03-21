import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Должность и квалификация',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: selectedRole,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.work),
          ),
          items: const [
            DropdownMenuItem(
              value: 'tennisCoach',
              child: Text('Тренер по теннису'),
            ),
            DropdownMenuItem(
              value: 'physicalCoach',
              child: Text('Тренер по ОФП'),
            ),
            DropdownMenuItem(value: 'admin', child: Text('Администратор')),
          ],
          onChanged: onRoleChanged,
        ),
        const SizedBox(height: 16),
        if (selectedRole != 'admin') ...[
          CustomTextField(
            controller: qualCtrl,
            label: 'Квалификация (например: МСМК)',
            prefixIcon: Icons.star,
          ),
          CustomTextField(
            controller: specCtrl,
            label: 'Специализация (например: Дети)',
            prefixIcon: Icons.sports_tennis,
          ),
        ],
      ],
    );
  }
}
