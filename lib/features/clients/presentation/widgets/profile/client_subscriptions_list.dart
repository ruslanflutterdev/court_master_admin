import 'package:flutter/material.dart';
import '../../../data/models/subscription_model.dart';
import '../../utils/subscription_helper.dart';

class ClientSubscriptionsList extends StatelessWidget {
  final List<SubscriptionModel> subscriptions;

  const ClientSubscriptionsList({super.key, required this.subscriptions});

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return const Center(
        child: Text(
          'У клиента пока нет абонементов',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        final sub = subscriptions[index];
        final isActive = sub.status == 1;
        final color = SubscriptionHelper.getTypeColor(sub.type);

        final isUnlimited = sub.type == 3;
        final progressText = isUnlimited
            ? '∞ (Безлимит)'
            : '${sub.usedClasses} из ${sub.totalClasses} занятий';

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: isActive ? Colors.white : Colors.grey.shade100,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isActive ? color.withAlpha(150) : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
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
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                progressText,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.shade50
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isActive ? 'Активен' : 'Завершен',
                    style: TextStyle(
                      color: isActive
                          ? Colors.green.shade700
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                if (sub.validUntil != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'до ${sub.validUntil!.day.toString().padLeft(2, '0')}.${sub.validUntil!.month.toString().padLeft(2, '0')}.${sub.validUntil!.year}',
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
