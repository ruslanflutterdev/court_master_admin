import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/client_details_bloc.dart';

class AddSubscriptionSheet extends StatefulWidget {
  final String clientId;
  const AddSubscriptionSheet({super.key, required this.clientId});

  @override
  State<AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<AddSubscriptionSheet> {
  int _selectedType = 2; // По умолчанию выбран "Пакет занятий"
  final _classesController = TextEditingController(text: '8');
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Продать абонемент',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Тип абонемента',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 1, child: Text('Разовое занятие')),
              DropdownMenuItem(value: 2, child: Text('Пакет занятий')),
              DropdownMenuItem(value: 3, child: Text('Безлимит')),
            ],
            onChanged: (val) => setState(() => _selectedType = val!),
          ),
          const SizedBox(height: 16),
          if (_selectedType == 2)
            TextField(
              controller: _classesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Количество занятий',
                border: OutlineInputBorder(),
              ),
            ),
          if (_selectedType == 2) const SizedBox(height: 16),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Стоимость абонемента',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              final price = int.tryParse(_priceController.text) ?? 0;
              final classes = _selectedType == 2
                  ? (int.tryParse(_classesController.text) ?? 1)
                  : 1;

              if (price > 0) {
                context.read<ClientDetailsBloc>().add(
                  AddSubscriptionEvent(widget.clientId, {
                    'type': _selectedType,
                    'totalClasses': classes,
                    'price': price,
                  }),
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Продать',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
