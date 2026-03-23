import 'package:flutter/material.dart';
import '../../../../clients/data/models/client_model.dart';

class ScheduleRentForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final List<ClientModel> allClients;

  const ScheduleRentForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.allClients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Autocomplete<ClientModel>(
          displayStringForOption: (client) => client.firstName,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<ClientModel>.empty();
            }
            return allClients.where(
              (client) =>
                  client.firstName.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ) ||
                  client.lastName.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ) ||
                  (client.phone?.contains(textEditingValue.text) ?? false),
            );
          },
          onSelected: (ClientModel selection) {
            firstNameController.text = selection.firstName;
            lastNameController.text = selection.lastName;
            phoneController.text = selection.phone ?? '';
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            if (firstNameController.text != controller.text &&
                firstNameController.text.isNotEmpty) {
              controller.text = firstNameController.text;
            }
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Имя (обязательно)',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => firstNameController.text = val,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Введите имя' : null,
            );
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: lastNameController,
          decoration: const InputDecoration(
            labelText: 'Фамилия (не обязательно)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Телефон (не обязательно)',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
