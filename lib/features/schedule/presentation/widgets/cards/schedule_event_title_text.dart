import 'package:flutter/material.dart';
import '../../../../schedule/data/models/schedule_event_model.dart';

class ScheduleEventTitleText extends StatelessWidget {
  final ScheduleEventModel event;
  final TextStyle style;

  const ScheduleEventTitleText({
    super.key,
    required this.event,
    required this.style,
  });

  // Вспомогательный метод ВЫШЕ build
  String _getEventTitle() {
    switch (event.eventType) {
      case 'rent':
        return 'Аренда';
      case 'group':
        final groupName = event.groupName ?? 'Группа';
        final coachName = event.coachFullName != null
            ? ' (${event.coachFullName})'
            : '';
        return '$groupName$coachName';
      case 'tournament':
        return '🏆 Турнир';
      case 'maintenance':
        return '🔧 Тех. работы';
      default:
        return 'Событие';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getEventTitle(),
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
