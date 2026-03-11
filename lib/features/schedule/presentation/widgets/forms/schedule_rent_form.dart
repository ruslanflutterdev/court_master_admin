import 'package:flutter/material.dart';
import '../../../../employees/data/models/coach_model.dart';

class ScheduleRentForm extends StatelessWidget {
  final TextEditingController clientNameController;
  final TextEditingController clientPhoneController;
  final List<CoachModel> coaches;
  final String? selectedCoachId;
  final Function(String?) onCoachSelected;

  const ScheduleRentForm({
    super.key,
    required this.clientNameController,
    required this.clientPhoneController,
    required this.coaches,
    required this.selectedCoachId,
    required this.onCoachSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: clientNameController,
          decoration: const InputDecoration(
            labelText: 'Имя клиента',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Введите имя' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: clientPhoneController,
          decoration: const InputDecoration(
            labelText: 'Телефон клиента',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Тренер (опционально)',
            border: OutlineInputBorder(),
          ),
          initialValue: selectedCoachId,
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('Без тренера'),
            ),
            ...coaches.map(
              (coach) => DropdownMenuItem(
                value: coach.id,
                child: Text('${coach.firstName} ${coach.lastName}'),
              ),
            ),
          ],
          onChanged: onCoachSelected,
        ),
      ],
    );
  }
}
