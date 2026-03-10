import 'package:flutter/material.dart';
import '../../data/models/schedule_event_model.dart';

class ScheduleEventCard extends StatelessWidget {
  final ScheduleEventModel event;
  final bool isPastDate;
  final VoidCallback onTap;

  const ScheduleEventCard({
    super.key,
    required this.event,
    required this.isPastDate,
    required this.onTap,
  });

  Color _parseColor(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red.shade300;
      case 'blue':
        return Colors.blue.shade300;
      case 'green':
        return Colors.green.shade300;
      case 'orange':
        return Colors.orange.shade300;
      case 'purple':
        return Colors.purple.shade300;
      default:
        return Colors.blue.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    final startHour = event.startTime.hour;
    final startMinute = event.startTime.minute;
    final endHour = event.endTime.hour;
    final endMinute = event.endTime.minute;

    final topPosition = ((startHour - 6) * 80.0) + (startMinute / 60.0 * 80.0);
    final height =
        ((endHour - startHour) * 80.0) +
        ((endMinute - startMinute) / 60.0 * 80.0);

    final title = event.eventType == 'group'
        ? 'Группа'
        : (event.clientName ?? 'Аренда');

    return Positioned(
      top: topPosition,
      left: 4,
      right: 4,
      height: height,
      child: GestureDetector(
        onTap: isPastDate ? null : onTap,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: _parseColor(event.color),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${startHour.toString().padLeft(2, '0')}:${startMinute.toString().padLeft(2, '0')} - ${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
