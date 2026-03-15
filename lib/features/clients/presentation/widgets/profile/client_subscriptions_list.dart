import 'package:flutter/material.dart';
import '../../../data/models/subscription_model.dart';
import '../../utils/subscription_helper.dart';

class ClientSubscriptionsList extends StatelessWidget {
  final List<SubscriptionModel> subscriptions;

  const ClientSubscriptionsList({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const Text(
        'У клиента пока нет абонементов',
        style: TextStyle(color: Colors.grey),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: subscriptions.map((sub) {
        final isActive = sub.status == 1;
        final color = SubscriptionHelper.getTypeColor(sub.type);

        final isUnlimited = sub.type == 3;
        final progressText = isUnlimited
            ? '∞ (Безлимит)'
            : '${sub.usedClasses} из ${sub.totalClasses} занятий';

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: isActive ? Colors.white : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isActive ? color.withAlpha(150) : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isActive
                  ? color.withAlpha(70)
                  : Colors.grey.shade300,
              child: Icon(
                isUnlimited ? Icons.all_inclusive : Icons.style,
                color: isActive ? color : Colors.grey,
              ),
            ),
            title: Text(
              SubscriptionHelper.getTypeName(sub.type),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.black87 : Colors.grey,
                decoration: isActive ? null : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(progressText),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  isActive ? 'Активен' : 'Завершен',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (sub.validUntil != null)
                  Text(
                    'до ${sub.validUntil!.day}.${sub.validUntil!.month.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
