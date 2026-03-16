import 'package:flutter/material.dart';
import '../../bloc/schedule_state.dart';
import '../../../../schedule/data/models/schedule_event_model.dart';
import 'schedule_grid_view.dart';
import 'common/time_column.dart';

class ScheduleBody extends StatelessWidget {
  final ScheduleLoaded state;
  final bool isPastDate;
  final Function(String, String) onEditCourt;
  final Function(String, int, int) onTimeSlotTapped;
  final Function(ScheduleEventModel) onEventTapped;

  const ScheduleBody({
    super.key,
    required this.state,
    required this.isPastDate,
    required this.onEditCourt,
    required this.onTimeSlotTapped,
    required this.onEventTapped,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      minScale: 0.3,
      maxScale: 1.5,
      boundaryMargin: const EdgeInsets.only(bottom: 200, right: 100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TimeColumn(),
          ScheduleGridView(
            state: state,
            isPastDate: isPastDate,
            onEditCourt: onEditCourt,
            onTimeSlotTapped: onTimeSlotTapped,
            onEventTapped: onEventTapped,
          ),
        ],
      ),
    );
  }
}
