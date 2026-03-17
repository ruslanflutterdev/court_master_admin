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
  final _formKey = GlobalKey<FormState>();

  ClientModel? _selectedClient;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _saleType = 'rent';
  final _priceController = TextEditingController();
  int _paymentMethod = 1;
  bool get _isNewClient => _selectedClient == null;
  String? get _selectedClientId => _selectedClient?.id;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'isNewClient': _isNewClient,
        'clientId': _selectedClientId,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),

        'saleCategory': _saleType,
        'price': int.tryParse(_priceController.text) ?? 0,
        'paymentMethod': _paymentMethod,
      };

      if (_saleType == 'group_sub' || _saleType == 'indiv_sub') {
        data['totalClasses'] = 8;
      } else {
        data['totalClasses'] = 1;
      }

      context.read<ClientsBloc>().add(QuickSaleRequested(data));
      Navigator.pop(context);
    }
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
        child: Form(
          key: _formKey,
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

              if (_isNewClient) ...[
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
                selectedSaleType: _saleType,
                paymentMethod: _paymentMethod,
                onSaleTypeChanged: (val) => setState(() => _saleType = val),
                onPaymentMethodChanged: (val) => setState(() => _paymentMethod = val),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Сумма к оплате (₸)',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Введите сумму';
                  if (int.tryParse(value) == null) return 'Введите корректное число';
                  return null;
                },
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
      ),
    );
  }
}