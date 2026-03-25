import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/clients_bloc.dart';
import '../../bloc/clients_state.dart';
import '../inputs/client_autocomplete.dart';
import '../inputs/quick_sale_new_client_inputs.dart';

class QuickSaleClientSection extends StatelessWidget {
  final ClientModel? selectedClient;
  final ValueChanged<ClientModel?> onClientSelected;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController companyCtrl;
  final TextEditingController innCtrl;
  final TextEditingController kppCtrl;
  final ValueChanged<bool> onCorporateChanged;
  final ValueChanged<String?> onSkillChanged;
  final ValueChanged<String?> onSourceChanged;

  const QuickSaleClientSection({
    super.key,
    required this.selectedClient,
    required this.onClientSelected,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.companyCtrl,
    required this.innCtrl,
    required this.kppCtrl,
    required this.onCorporateChanged,
    required this.onSkillChanged,
    required this.onSourceChanged,
  });

  @override
  Widget build(BuildContext context) {
    final clientsState = context.watch<ClientsBloc>().state;
    final clientsList = clientsState is ClientsLoaded
        ? clientsState.clients
        : <ClientModel>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Клиент', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        ClientAutocomplete(
          clients: clientsList,
          selectedClient: selectedClient,
          onSelected: onClientSelected,
          onCleared: () => onClientSelected(null),
        ),

        if (selectedClient == null) ...[
          const SizedBox(height: 16),
          QuickSaleNewClientInputs(
            firstNameCtrl: firstNameCtrl,
            lastNameCtrl: lastNameCtrl,
            phoneCtrl: phoneCtrl,
            companyCtrl: companyCtrl,
            innCtrl: innCtrl,
            kppCtrl: kppCtrl,
            onCorporateChanged: onCorporateChanged,
            onSkillChanged: onSkillChanged,
            onSourceChanged: onSourceChanged,
          ),
        ],
      ],
    );
  }
}
