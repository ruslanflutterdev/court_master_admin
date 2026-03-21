import 'package:flutter/material.dart';
import '../../../../clients/data/models/client_model.dart';
import '../../../../groups/data/models/group_model.dart';
import 'schedule_group_form.dart';
import 'schedule_rent_form.dart';

class ScheduleDynamicFormSection extends StatelessWidget {
  final String type;
  final List<GroupModel> groups;
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupSelected;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final List<ClientModel> allClients;

  const ScheduleDynamicFormSection({
    super.key,
    required this.type,
    required this.groups,
    required this.selectedGroupId,
    required this.onGroupSelected,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.allClients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        if (type == 'group')
          ScheduleGroupForm(
            groups: groups,
            selectedGroupId: selectedGroupId,
            onGroupSelected: onGroupSelected,
          )
        else
          ScheduleRentForm(
            firstNameController: firstNameController,
            lastNameController: lastNameController,
            phoneController: phoneController,
            allClients: allClients,
          ),
      ],
    );
  }
}
