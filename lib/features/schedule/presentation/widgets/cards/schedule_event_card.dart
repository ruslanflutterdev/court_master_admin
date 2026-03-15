import 'package:flutter/material.dart';
import '../../../../schedule/data/models/schedule_event_model.dart';
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
    final startHour = event.startTime.hour;
    final startMinute = event.startTime.minute;
    final endHour = event.endTime.hour;
    final endMinute = event.endTime.minute;

    final topOffset = ((startHour - 6) * 80.0) + (startMinute / 60.0 * 80.0);
    final height =
        ((endHour - startHour) * 80.0) +
        ((endMinute - startMinute) / 60.0 * 80.0);

    final color = ScheduleColorHelper.getColorForEventType(
      event.eventType,
      dbColorHex: event.colorHex,
    );

    String fmt(TimeOfDay t) =>
        "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

    final cardWidget = Container(
      margin: const EdgeInsets.only(top: 2, bottom: 3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(isPastDate ? 80 : 150),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(150),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getEventTitle(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '${fmt(event.startTime)} - ${fmt(event.endTime)}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          if (event.clientName != null && event.clientName!.isNotEmpty)
            Text(
              event.clientName!,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );

    return Positioned(
      top: topOffset,
      height: height,
      left: 4,
      right: 4,
      child: isPastDate
          ? GestureDetector(onTap: onTap, child: cardWidget)
          : LongPressDraggable<ScheduleEventModel>(
              data: event,
              delay: const Duration(milliseconds: 300),
              feedback: Material(
                color: Colors.transparent,
                child: Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    width: 150,
                    height: height,
                    child: cardWidget,
                  ),
                ),
              ),
              childWhenDragging: Opacity(opacity: 0.3, child: cardWidget),
              child: GestureDetector(onTap: onTap, child: cardWidget),
            ),
    );
  }

  String _getEventTitle() {
    switch (event.eventType) {
      case 'rent':
        return 'Аренда';
      case 'group':
        return 'Группа';
      case 'individual':
        return 'Инд. тренировка';
      case 'tournament':
        return '🏆 Турнир';
      case 'maintenance':
        return '🔧 Тех. работы';
      default:
        return 'Событие';
    }
  }
}
