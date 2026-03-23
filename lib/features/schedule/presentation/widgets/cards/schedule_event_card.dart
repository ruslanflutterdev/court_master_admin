import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/bloc/auth_state.dart';
import '../../../../auth/data/models/user_model.dart';
import '../../../../schedule/data/models/schedule_event_model.dart';
import '../../utils/schedule_color_helper.dart';
import 'schedule_event_title_text.dart';

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

  String _fmt(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isCoach =
        authState is AuthAuthenticated && authState.user.role == AppRoles.coach;

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
          ScheduleEventTitleText(
            event: event,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${_fmt(event.startTime)} - ${_fmt(event.endTime)}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          if (!isCoach &&
              event.clientName != null &&
              event.clientName!.isNotEmpty)
            Text(
              event.clientName!,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );

    if (isCoach) {
      return Positioned(
        top: topOffset,
        height: height,
        left: 4,
        right: 4,
        child: cardWidget,
      );
    }

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
}
