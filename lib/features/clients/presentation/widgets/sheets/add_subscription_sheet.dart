import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/client_details_bloc.dart';
import '../../bloc/client_details_event.dart'; // Импорт событий
import '../../utils/subscription_helper.dart';

class AddSubscriptionSheet extends StatefulWidget {
  final String clientId;

  const AddSubscriptionSheet({super.key, required this.clientId});

  @override
  State<AddSubscriptionSheet> createState() => _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends State<AddSubscriptionSheet> {
  int selectedType = 2;
  final classesCtrl = TextEditingController(text: '8');
  final priceCtrl = TextEditingController();
  DateTime? validUntil;

  @override
  Widget build(BuildContext context) {
    final types = List.generate(7, (index) => index + 1);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Оформить абонемент',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField<int>(
              initialValue: selectedType, // ИСПРАВЛЕНИЕ: Вернули initialValue
              decoration: const InputDecoration(labelText: 'Тип абонемента'),
              items: types.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(SubscriptionHelper.getTypeName(type)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => selectedType = val);
                }
              },
            ),

            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                SubscriptionHelper.getTypeDescription(selectedType),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            if (SubscriptionHelper.requiresManualClassCount(selectedType))
              TextField(
                controller: classesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Количество занятий',
                ),
                keyboardType: TextInputType.number,
              ),

            TextField(
              controller: priceCtrl,
              decoration: const InputDecoration(labelText: 'Стоимость (₸)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                validUntil == null
                    ? 'Срок действия: Не ограничен'
                    : 'Действует до: ${validUntil!.day}.${validUntil!.month}.${validUntil!.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                );
                if (date != null) setState(() => validUntil = date);
              },
            ),

            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                int totalClasses = int.tryParse(classesCtrl.text) ?? 1;
                if (selectedType == 1) totalClasses = 1;
                if (selectedType == 3) totalClasses = 9999;

                // ИСПРАВЛЕНИЕ: Используем правильное имя класса (AddSubscriptionEvent)
                // и передаем параметры как позиционные (сначала clientId, потом Map)
                context.read<ClientDetailsBloc>().add(
                  AddSubscriptionEvent(widget.clientId, {
                    'type': selectedType,
                    'totalClasses': totalClasses,
                    'price': int.tryParse(priceCtrl.text) ?? 0,
                    if (validUntil != null)
                      'validUntil': validUntil!.toIso8601String(),
                  }),
                );
                Navigator.pop(context);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
