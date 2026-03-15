import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../schedule/data/models/schedule_event_model.dart';
import '../../bloc/schedule_state.dart';
import '../../bloc/schedule_bloc.dart';
import '../../bloc/schedule_event.dart';
import '../cards/schedule_event_card.dart';

class ScheduleGridView extends StatelessWidget {
  final ScheduleLoaded state;
  final bool isPastDate;
  final Function(String courtId, String courtName) onEditCourt;
  final Function(String courtId, int hour, int minute) onTimeSlotTapped;
  final Function(ScheduleEventModel event) onEventTapped;

  const ScheduleGridView({
    super.key,
    required this.state,
    required this.isPastDate,
    required this.onEditCourt,
    required this.onTimeSlotTapped,
    required this.onEventTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (state.courts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Создайте первый корт, нажав на кнопку "+ Корт"'),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: state.courts.map((court) {
        final courtEvents = state.scheduleEvents
            .where((e) => e.courtId == court.id)
            .toList();

        return Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey.shade300),
              right: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
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
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.blue,
                        ),
                        onPressed: () => onEditCourt(court.id, court.name),
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

                        return DragTarget<ScheduleEventModel>(
                          onWillAcceptWithDetails: (details) => !isPastDate,
                          onAcceptWithDetails: (details) {
                            final draggedEvent = details.data;

                            final durationMinutes =
                                (draggedEvent.endTime.hour * 60 +
                                    draggedEvent.endTime.minute) -
                                (draggedEvent.startTime.hour * 60 +
                                    draggedEvent.startTime.minute);

                            final newStartTotalMinutes = hour * 60 + minute;
                            final newEndTotalMinutes =
                                newStartTotalMinutes + durationMinutes;

                            final newEndHour = newEndTotalMinutes ~/ 60;
                            final newEndMinute = newEndTotalMinutes % 60;

                            String fmt(int h, int m) =>
                                "${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}";

                            context.read<ScheduleBloc>().add(
                              UpdateScheduleEvent(
                                eventId: draggedEvent.id,
                                currentDate: state.scheduleDate,
                                eventData: {
                                  'courtId': court.id,
                                  'startTime': fmt(hour, minute),
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
                          },
                          builder: (context, candidateData, rejectedData) {
                            final isHovered = candidateData.isNotEmpty;

                            return GestureDetector(
                              onTap: () =>
                                  onTimeSlotTapped(court.id, hour, minute),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isHovered
                                      ? Colors.blue.withAlpha(40)
                                      : Colors.transparent,
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
      }).toList(),
    );
  }
}
