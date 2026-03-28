import 'package:flutter/material.dart';

class WaitlistGroupForm extends StatelessWidget {
  final TextEditingController lastNameCtrl;
  final TextEditingController gameLevelCtrl;
  final TextEditingController commentCtrl;
  final String? selectedAge;
  final ValueChanged<String?> onAgeChanged;

  const WaitlistGroupForm({
    super.key,
    required this.lastNameCtrl,
    required this.gameLevelCtrl,
    required this.commentCtrl,
    required this.selectedAge,
    required this.onAgeChanged,
  });

  static const List<String> _ageOptions = [
    '3-4',
    '5-6',
    '7-8',
    '9-10',
    '11-12',
    '13-14',
    '15-17',
    '18+',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: lastNameCtrl,
          decoration: const InputDecoration(labelText: 'Фамилия'),
        ),
        TextField(
          controller: gameLevelCtrl,
          decoration: const InputDecoration(labelText: 'Уровень игры'),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Возраст'),
          initialValue: selectedAge,
          items: _ageOptions.map((age) {
            return DropdownMenuItem(value: age, child: Text(age));
          }).toList(),
          onChanged: onAgeChanged,
        ),
        TextField(
          controller: commentCtrl,
          decoration: const InputDecoration(
            labelText: 'Комментарий администратора',
          ),
          maxLines: 2,
        ),
      ],
    );
  }
}
