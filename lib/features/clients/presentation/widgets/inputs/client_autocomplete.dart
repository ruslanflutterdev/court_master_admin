import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';

class ClientAutocomplete extends StatelessWidget {
  final List<ClientModel> clients;
  final ClientModel? selectedClient;
  final Function(ClientModel?) onSelected;
  final VoidCallback onCleared;

  const ClientAutocomplete({
    super.key,
    required this.clients,
    required this.selectedClient,
    required this.onSelected,
    required this.onCleared,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<ClientModel>(
      displayStringForOption: (option) =>
          '${option.firstName} ${option.lastName} ${option.phone ?? ''}'.trim(),
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<ClientModel>.empty();
        }
        return clients.where((client) {
          final searchStr =
              '${client.firstName} ${client.lastName} ${client.phone}'
                  .toLowerCase();
          return searchStr.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: onSelected,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: 'Поиск: Имя или Телефон',
                border: const OutlineInputBorder(),
                suffixIcon: selectedClient != null
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          textEditingController.clear();
                          onCleared();
                        },
                      )
                    : const Icon(Icons.search),
              ),
              onChanged: (val) {
                if (selectedClient != null) onCleared();
              },
            );
          },
    );
  }
}
