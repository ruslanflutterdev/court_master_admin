import 'package:flutter/material.dart';
import '../../utils/waitlist_actions.dart';

class ScheduleHeader extends StatelessWidget {
  final DateTime date;
  final bool isPastDate;
  final VoidCallback onCreateCourt;
  final VoidCallback onQuickSale;
  final String currentView;
  final Function(String) onViewChanged;

  const ScheduleHeader({
    super.key,
    required this.date,
    required this.isPastDate,
    required this.onCreateCourt,
    required this.onQuickSale,
    required this.currentView,
    required this.onViewChanged,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonHeight = 44.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.flash_on, size: 16),
                    label: const FittedBox(
                      child: Text(
                        'Продажа',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onQuickSale,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: const FittedBox(
                      child: Text(
                        'Ожидание',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade100,
                      foregroundColor: Colors.orange.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () =>
                        WaitlistActions.openWaitlistSheet(context, date),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: const FittedBox(
                      child: Text(
                        'Корт',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onCreateCourt,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SizedBox(
                  height: buttonHeight,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'day',
                        label: FittedBox(
                          child: Text('День', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      ButtonSegment(
                        value: 'week',
                        label: FittedBox(
                          child: Text('Неделя', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ],
                    selected: {currentView},
                    onSelectionChanged: (newSelection) =>
                        onViewChanged(newSelection.first),
                    showSelectedIcon: false,
                  ),
                ),
              ),
            ],
          ),

          if (isPastDate) ...[
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text('Прошлое', style: TextStyle(fontSize: 10)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
