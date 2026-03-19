import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/di/dependencies_container.dart';
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
  int _classesCount = 8;
  int _paymentMethod = 1;
  final _priceController = TextEditingController();
  final _rentPriceController = TextEditingController();
  final _coachPriceController = TextEditingController();

  List<dynamic> _coaches = [];
  bool _isLoadingCoaches = false;
  String? _selectedCoachId;

  bool get _isNewClient => _selectedClient == null;

  String? get _selectedClientId => _selectedClient?.id;

  bool get _needsCoach =>
      _saleType == 'indiv_training' ||
      _saleType == 'group_sub' ||
      _saleType == 'indiv_sub' ||
      _saleType == 'single';

  @override
  void initState() {
    super.initState();
    _fetchCoaches();
  }

  Future<void> _fetchCoaches() async {
    setState(() => _isLoadingCoaches = true);
    try {
      final response = await sl<ApiClient>().dio.get('/employees/coaches');
      setState(() {
        _coaches = response.data as List<dynamic>;
        if (_coaches.isNotEmpty) {
          _selectedCoachId = _coaches.first['id'].toString();
        }
      });
    } catch (e) {
      debugPrint('Ошибка загрузки тренеров: $e');
    } finally {
      if (mounted) setState(() => _isLoadingCoaches = false);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_needsCoach && _selectedCoachId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Пожалуйста, выберите тренера!')),
        );
        return;
      }

      final data = {
        'isNewClient': _isNewClient,
        'clientId': _selectedClientId,
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'saleCategory': _saleType,
        'paymentMethod': _paymentMethod,
      };

      if (_needsCoach) {
        data['coachId'] = _selectedCoachId;
      }
      if (_saleType == 'indiv_training') {
        data['rentPrice'] = int.tryParse(_rentPriceController.text) ?? 0;
        data['coachPrice'] = int.tryParse(_coachPriceController.text) ?? 0;
        data['price'] = 0;
      } else {
        data['price'] = int.tryParse(_priceController.text) ?? 0;
      }

      if (_saleType == 'group_sub' || _saleType == 'indiv_sub') {
        data['totalClasses'] = _classesCount;
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
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
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              QuickSalePurchaseInputs(
                selectedSaleType: _saleType,
                paymentMethod: _paymentMethod,
                onSaleTypeChanged: (val) => setState(() => _saleType = val),
                onPaymentMethodChanged: (val) =>
                    setState(() => _paymentMethod = val),
              ),

              if (_saleType == 'group_sub') ...[
                const SizedBox(height: 16),
                const Text(
                  'Пакет тренировок (на 4 недели)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 8, label: Text('8 занятий')),
                    ButtonSegment(value: 12, label: Text('12 занятий')),
                  ],
                  selected: {_classesCount},
                  onSelectionChanged: (newSelection) =>
                      setState(() => _classesCount = newSelection.first),
                ),
              ],

              if (_needsCoach) ...[
                const SizedBox(height: 16),
                const Text(
                  'Исполнитель (Тренер)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isLoadingCoaches)
                  const Center(child: CircularProgressIndicator())
                else
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCoachId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _coaches.map((coach) {
                      return DropdownMenuItem<String>(
                        value: coach['id'].toString(),
                        child: Text(
                          '${coach['firstName']} ${coach['lastName']}',
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedCoachId = val),
                    validator: (val) => val == null ? 'Выберите тренера' : null,
                  ),
              ],

              if (_saleType == 'indiv_training') ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _rentPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Аренда корта (₸)',
                          prefixIcon: const Icon(Icons.sports_tennis),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введите сумму'
                            : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _coachPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Оплата тренеру (₸)',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Введите сумму'
                            : null,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Сумма к оплате (₸)',
                    prefixIcon: const Icon(Icons.attach_money),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Введите сумму';
                    if (int.tryParse(value) == null) {
                      return 'Введите корректное число';
                    }
                    return null;
                  },
                ),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
