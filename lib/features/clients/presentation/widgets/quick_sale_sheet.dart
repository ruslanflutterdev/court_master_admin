import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart';
import '../bloc/clients_bloc.dart';

class QuickSaleSheet extends StatefulWidget {
  const QuickSaleSheet({super.key});

  @override
  State<QuickSaleSheet> createState() => _QuickSaleSheetState();
}

class _QuickSaleSheetState extends State<QuickSaleSheet> {
  ClientModel? _selectedClient; // Если выбрали из списка

  // Контроллеры для нового клиента
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  // Контроллеры для продажи
  int _subType = 1; // 1 = Разовое, 2 = Пакет
  final _classesController = TextEditingController(text: '1');
  final _priceController = TextEditingController();
  int _paymentMethod = 1; // 1 = Наличные, 2 = Карта, 3 = Перевод

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

            // --- УМНЫЙ ПОИСК (AUTOCOMPLETE) ---
            BlocBuilder<ClientsBloc, ClientsState>(
              builder: (context, state) {
                List<ClientModel> allClients = [];
                if (state is ClientsLoaded) {
                  allClients = state.clients;
                }

                return Autocomplete<ClientModel>(
                  displayStringForOption: (option) =>
                      '${option.firstName} ${option.lastName} ${option.phone ?? ''}'
                          .trim(),
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<ClientModel>.empty();
                    }
                    return allClients.where((client) {
                      final searchStr =
                          '${client.firstName} ${client.lastName} ${client.phone}'
                              .toLowerCase();
                      return searchStr.contains(
                        textEditingValue.text.toLowerCase(),
                      );
                    });
                  },
                  onSelected: (ClientModel selection) {
                    setState(() {
                      _selectedClient = selection;
                    });
                  },
                  fieldViewBuilder:
                      (
                        context,
                        textEditingController,
                        focusNode,
                        onFieldSubmitted,
                      ) {
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            labelText: 'Поиск: Имя или Телефон',
                            border: const OutlineInputBorder(),
                            suffixIcon: _selectedClient != null
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      textEditingController.clear();
                                      setState(() => _selectedClient = null);
                                    },
                                  )
                                : const Icon(Icons.search),
                          ),
                          onChanged: (val) {
                            if (_selectedClient != null) {
                              setState(
                                () => _selectedClient = null,
                              ); // Сбрасываем, если начали стирать
                            }
                          },
                        );
                      },
                );
              },
            ),

            // Если клиент не выбран (создаем нового)
            if (_selectedClient == null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'Имя (Новый)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Фамилия',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Телефон',
                  border: OutlineInputBorder(),
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              '2. Покупка',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              initialValue: _subType,
              decoration: const InputDecoration(
                labelText: 'Что продаем?',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 1,
                  child: Text('Разовое занятие / Аренда'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('Пакет занятий (Абонемент)'),
                ),
              ],
              onChanged: (val) => setState(() => _subType = val!),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                if (_subType == 2) ...[
                  Expanded(
                    child: TextField(
                      controller: _classesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Кол-во',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Сумма (₸)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<int>(
              initialValue: _paymentMethod,
              decoration: const InputDecoration(
                labelText: 'Способ оплаты',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Наличные')),
                DropdownMenuItem(value: 2, child: Text('Карта / Терминал')),
                DropdownMenuItem(value: 3, child: Text('Перевод / СБП')),
              ],
              onChanged: (val) => setState(() => _paymentMethod = val!),
            ),

            const SizedBox(height: 24),
            Builder(
              builder: (ctx) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    final price = int.tryParse(_priceController.text) ?? 0;
                    final classes = _subType == 2
                        ? (int.tryParse(_classesController.text) ?? 1)
                        : 1;

                    if (price <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Введите сумму!')),
                      );
                      return;
                    }
                    if (_selectedClient == null &&
                        _firstNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Укажите имя клиента!')),
                      );
                      return;
                    }

                    // Отправляем запрос на сервер
                    ctx.read<ClientsBloc>().add(
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

                    Navigator.pop(context); // Закрываем шторку
                  },
                  child: const Text(
                    'Провести продажу',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
