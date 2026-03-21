import 'package:flutter/material.dart';
import '../../../data/models/schedule_event_model.dart';
import '../../bloc/schedule_state.dart';
import 'schedule_court_column.dart';

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

        return ScheduleCourtColumn(
          court: court,
          courtEvents: courtEvents,
          scheduleDate: state.scheduleDate,
          isPastDate: isPastDate,
          onEditCourt: () => onEditCourt(court.id, court.name),
          onTimeSlotTapped: (h, m) => onTimeSlotTapped(court.id, h, m),
          onEventTapped: onEventTapped,
        );
      }).toList(),
    );
  }
}
