import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/client_model.dart';
import '../../bloc/clients_bloc.dart';
import '../../bloc/clients_state.dart';
import '../inputs/client_autocomplete.dart';
import '../inputs/quick_sale_new_client_inputs.dart';

class QuickSaleClientSection extends StatelessWidget {
  final ClientModel? selectedClient;
  final Function(ClientModel?) onClientSelected;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;

  const QuickSaleClientSection({
    super.key,
    required this.selectedClient,
    required this.onClientSelected,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '1. Клиент',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, state) => ClientAutocomplete(
            clients: state is ClientsLoaded ? state.clients : [],
            selectedClient: selectedClient,
            onSelected: onClientSelected,
            onCleared: () => onClientSelected(null),
          ),
        ),
        if (selectedClient == null) ...[
          const SizedBox(height: 12),
          QuickSaleNewClientInputs(
            firstNameController: firstNameCtrl,
            lastNameController: lastNameCtrl,
            phoneController: phoneCtrl,
          ),
        ],
      ],
    );
  }
}
