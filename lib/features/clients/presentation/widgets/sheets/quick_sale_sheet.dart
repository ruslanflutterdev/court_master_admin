import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/client_model.dart';
import '../../bloc/clients_bloc.dart';
import '../../bloc/clients_event.dart';
import '../../bloc/clients_state.dart';
import '../inputs/client_autocomplete.dart';
import '../inputs/quick_sale_new_client_inputs.dart';
import '../inputs/quick_sale_purchase_inputs.dart';

class QuickSaleSheet extends StatefulWidget {
  const QuickSaleSheet({super.key});

  @override
  State<QuickSaleSheet> createState() => _QuickSaleSheetState();
}

class _QuickSaleSheetState extends State<QuickSaleSheet> {
  ClientModel? _selectedClient;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  int _subType = 1;
  final _classesController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  int _paymentMethod = 1;

  void _submit() {
    final price = int.tryParse(_priceController.text) ?? 0;
    final classes = _subType == 2
        ? (int.tryParse(_classesController.text) ?? 1)
        : 1;

    if (price <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Введите сумму!')));
      return;
    }
    if (_selectedClient == null && _firstNameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Укажите имя клиента!')));
      return;
    }

    context.read<ClientsBloc>().add(
      QuickSaleRequested({
        'clientId': _selectedClient?.id,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
        'subType': _subType,
        'totalClasses': classes,
        'price': price,
        'paymentMethod': _paymentMethod,
      }),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.flash_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Быстрая продажа',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 32),

            const Text(
              '1. Клиент',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                final allClients = state is ClientsLoaded
                    ? state.clients
                    : <ClientModel>[];
                return ClientAutocomplete(
                  clients: allClients,
                  selectedClient: _selectedClient,
                  onSelected: (selection) =>
                      setState(() => _selectedClient = selection),
                  onCleared: () => setState(() => _selectedClient = null),
                );
              },
            ),

            if (_selectedClient == null) ...[
              const SizedBox(height: 12),
              QuickSaleNewClientInputs(
                firstNameController: _firstNameController,
                lastNameController: _lastNameController,
                phoneController: _phoneController,
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              '2. Покупка',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            QuickSalePurchaseInputs(
              subType: _subType,
              onSubTypeChanged: (val) => setState(() => _subType = val),
              classesController: _classesController,
              priceController: _priceController,
              paymentMethod: _paymentMethod,
              onPaymentMethodChanged: (val) =>
                  setState(() => _paymentMethod = val),
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.orange,
              ),
              onPressed: _submit,
              child: const Text(
                'Провести продажу',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
