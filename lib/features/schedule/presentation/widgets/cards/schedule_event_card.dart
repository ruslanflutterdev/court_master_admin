import 'package:flutter/material.dart';
import '../../../data/models/schedule_event_model.dart';
import '../../utils/schedule_color_helper.dart';

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

  @override
  Widget build(BuildContext context) {
    final topOffset =
        ((event.startTime.hour - 6) * 80.0) +
        (event.startTime.minute == 30 ? 40.0 : 0.0);

    final durationMinutes =
        (event.endTime.hour * 60 + event.endTime.minute) -
        (event.startTime.hour * 60 + event.startTime.minute);
    final height = (durationMinutes / 30.0) * 40.0;

    final cardColor = ScheduleColorHelper.getColorForEventType(
      event.eventType,
      dbColorHex: event.colorHex,
    );

    return Positioned(
      top: topOffset,
      left: 4,
      right: 4,
      height: height,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPastDate ? cardColor.withAlpha(150) : cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${event.startTime.format(context)} - ${event.endTime.format(context)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  _getEventTitle(),
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEventTitle() {
    if (event.eventType == 'maintenance') return '🔧 Техобслуживание';
    if (event.eventType == 'tournament') return '🏆 Турнир';
    if (event.eventType == 'group') return '👥 Группа';
    return event.clientName ?? 'Аренда';
  }
}
