import 'package:flutter/material.dart';
import '../../../data/models/schedule_event_model.dart';

class ScheduleTimeSlot extends StatelessWidget {
  final int hour;
  final int minute;
  final bool isPastDate;
  final VoidCallback onTap;
  final Function(ScheduleEventModel) onAcceptEvent;

  const ScheduleTimeSlot({
    super.key,
    required this.hour,
    required this.minute,
    required this.isPastDate,
    required this.onTap,
    required this.onAcceptEvent,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<ScheduleEventModel>(
      onWillAcceptWithDetails: (_) => !isPastDate,
      onAcceptWithDetails: (details) => onAcceptEvent(details.data),
      builder: (context, candidateData, _) {
        final isHovered = candidateData.isNotEmpty;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: isHovered ? Colors.blue.withAlpha(40) : Colors.transparent,
              border: Border(
                bottom: BorderSide(
                  color: minute == 30
                      ? Colors.grey.shade300
                      : Colors.grey.shade100,
                  width: minute == 30 ? 1 : 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
