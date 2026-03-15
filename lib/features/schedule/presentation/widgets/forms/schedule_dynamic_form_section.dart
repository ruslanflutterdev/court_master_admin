import 'package:flutter/material.dart';
import 'schedule_group_form.dart';
import 'schedule_rent_form.dart';
import '../../../../groups/data/models/group_model.dart';
import '../../../../employees/data/models/coach_model.dart';

class ScheduleDynamicFormSection extends StatelessWidget {
  final String type;
  final List<GroupModel> groups;
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupSelected;
  final List<CoachModel> coaches;
  final String? selectedCoachId;
  final ValueChanged<String?> onCoachSelected;
  final TextEditingController clientNameController;
  final TextEditingController clientPhoneController;

  const ScheduleDynamicFormSection({
    super.key,
    required this.type,
    required this.groups,
    required this.selectedGroupId,
    required this.onGroupSelected,
    required this.coaches,
    required this.selectedCoachId,
    required this.onCoachSelected,
    required this.clientNameController,
    required this.clientPhoneController,
  });

  @override
  Widget build(BuildContext context) {
    if (type == 'group') {
      return ScheduleGroupForm(
        groups: groups,
        selectedGroupId: selectedGroupId,
        onGroupSelected: onGroupSelected,
      );
    }
    return ScheduleRentForm(
      clientNameController: clientNameController,
      clientPhoneController: clientPhoneController,
      coaches: coaches,
      selectedCoachId: selectedCoachId,
      onCoachSelected: onCoachSelected,
    );
  }
}
