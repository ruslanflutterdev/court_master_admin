import 'package:flutter/material.dart';
import '../../utils/waitlist_actions.dart';

class WaitlistHeader extends StatelessWidget {
  final DateTime date;

  const WaitlistHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Лист ожидания',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.blue, size: 30),
          onPressed: () => WaitlistActions.openAddWaitlistSheet(context, date),
        ),
      ],
    );
  }
}
