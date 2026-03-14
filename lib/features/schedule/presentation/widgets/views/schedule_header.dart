import 'package:flutter/material.dart';
import '../../utils/waitlist_actions.dart';

class ScheduleHeader extends StatelessWidget {
  final DateTime date;
  final bool isPastDate;
  final VoidCallback onCreateCourt;

  const ScheduleHeader({
    super.key,
    required this.date,
    required this.isPastDate,
    required this.onCreateCourt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                'Расписание',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (isPastDate) ...[
                const SizedBox(width: 8),
                const Chip(
                  label: Text('Прошлое', style: TextStyle(fontSize: 10)),
                ),
              ],
            ],
          ),

          Row(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Корт'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue.shade900,
                  elevation: 0,
                ),
                onPressed: onCreateCourt,
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.list_alt, size: 18),
                label: const Text('Лист ожидания'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade100,
                  foregroundColor: Colors.orange.shade900,
                  elevation: 0,
                ),
                onPressed: () =>
                    WaitlistActions.openWaitlistSheet(context, date),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
