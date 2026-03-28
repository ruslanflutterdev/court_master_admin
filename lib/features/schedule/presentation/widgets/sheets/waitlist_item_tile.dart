import 'package:flutter/material.dart';
import '../../../data/models/waitlist_model.dart';

class WaitlistItemTile extends StatelessWidget {
  final WaitlistModel item;
  final bool isGroup;
  final VoidCallback onDelete;

  const WaitlistItemTile({
    super.key,
    required this.item,
    required this.isGroup,
    required this.onDelete,
  });

  String _getFullName() =>
      '${item.clientName ?? "Гость"} ${item.lastName ?? ""}';

  String _getSubtitle() {
    if (isGroup) {
      return '${item.clientPhone ?? ""}\n'
          'Возраст: ${item.ageGroup ?? "-"}, Уровень: ${item.gameLevel ?? "-"}\n'
          'Коммент: ${item.comment ?? "-"}';
    }
    return '${item.startTime ?? "-"} - ${item.endTime ?? "-"} | ${item.clientPhone ?? ""}';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_getFullName().trim()),
      subtitle: Text(_getSubtitle()),
      isThreeLine: isGroup,
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: onDelete,
      ),
    );
  }
}
