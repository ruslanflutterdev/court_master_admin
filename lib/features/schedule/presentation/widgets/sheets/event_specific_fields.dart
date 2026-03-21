import 'package:flutter/material.dart';
import '../../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../groups/data/models/group_model.dart';

class EventSpecificFields extends StatelessWidget {
  final String eventType;
  final String? selectedGroupId;
  final List<GroupModel> groups;
  final TextEditingController priceCtrl;
  final TextEditingController descCtrl;
  final ValueChanged<String?> onGroupChanged;

  const EventSpecificFields({
    super.key,
    required this.eventType,
    required this.selectedGroupId,
    required this.groups,
    required this.priceCtrl,
    required this.descCtrl,
    required this.onGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (eventType == 'group') {
      return DropdownButtonFormField<String>(
        initialValue: selectedGroupId,
        decoration: const InputDecoration(
          labelText: 'Выберите группу',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: groups.map<DropdownMenuItem<String>>((GroupModel g) {
          return DropdownMenuItem<String>(value: g.id, child: Text(g.name));
        }).toList(),
        onChanged: onGroupChanged,
      );
    }

    if (eventType == 'rent') {
      return Column(
        children: [
          CustomTextField(
            controller: priceCtrl,
            label: 'Стоимость аренды',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.payments,
          ),
          CustomTextField(
            controller: descCtrl,
            label: 'Комментарий (кто арендует)',
            prefixIcon: Icons.description,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}
