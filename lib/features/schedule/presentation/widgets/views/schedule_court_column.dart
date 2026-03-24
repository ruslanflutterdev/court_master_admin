import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/schedule_event_model.dart';
import '../../bloc/schedule_bloc.dart';
import '../../bloc/schedule_event.dart';
import '../cards/schedule_event_card.dart';
import 'schedule_time_slot.dart'; // 🚀 Новый виджет

class ScheduleCourtColumn extends StatelessWidget {
  final CourtModel court;
  final List<ScheduleEventModel> courtEvents;
  final DateTime scheduleDate;
  final bool isPastDate;
  final VoidCallback onEditCourt;
  final Function(int hour, int minute) onTimeSlotTapped;
  final Function(ScheduleEventModel event) onEventTapped;

  const ScheduleCourtColumn({
    super.key,
    required this.court,
    required this.courtEvents,
    required this.scheduleDate,
    required this.isPastDate,
    required this.onEditCourt,
    required this.onTimeSlotTapped,
    required this.onEventTapped,
  });

  void _onEventDropped(
    BuildContext context,
    ScheduleEventModel draggedEvent,
    int targetHour,
    int targetMinute,
  ) {
    final durationMinutes =
        (draggedEvent.endTime.hour * 60 + draggedEvent.endTime.minute) -
        (draggedEvent.startTime.hour * 60 + draggedEvent.startTime.minute);

    final newStartTotalMinutes = targetHour * 60 + targetMinute;
    final newEndTotalMinutes = newStartTotalMinutes + durationMinutes;

    final newEndHour = newEndTotalMinutes ~/ 60;
    final newEndMinute = newEndTotalMinutes % 60;

    String fmt(int h, int m) =>
        "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";

    context.read<ScheduleBloc>().add(
      UpdateScheduleEvent(
        eventId: draggedEvent.id,
        currentDate: scheduleDate,
        eventData: {
          'courtId': court.id,
          'startTime': fmt(targetHour, targetMinute),
          'endTime': fmt(newEndHour, newEndMinute),
          'type': draggedEvent.eventType,
          'colorHex': draggedEvent.colorHex,
          'groupId': draggedEvent.groupId,
          'clientName': draggedEvent.clientName,
          'clientPhone': draggedEvent.clientPhone,
          'coachId': draggedEvent.coachId,
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        border: Border.symmetric(
          vertical: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    court.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isPastDate)
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
                    onPressed: onEditCourt,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          SizedBox(
            height: 18 * 80.0,
            child: Stack(
              children: [
                Column(
                  children: List.generate(36, (index) {
                    final hour = 6 + (index ~/ 2);
                    final minute = (index % 2) == 0 ? 0 : 30;
                    return ScheduleTimeSlot(
                      hour: hour,
                      minute: minute,
                      isPastDate: isPastDate,
                      onTap: () => onTimeSlotTapped(hour, minute),
                      onAcceptEvent: (e) =>
                          _onEventDropped(context, e, hour, minute),
                    );
                  }),
                ),
                ...courtEvents.map(
                  (e) => ScheduleEventCard(
                    event: e,
                    isPastDate: isPastDate,
                    onTap: () => onEventTapped(e),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
