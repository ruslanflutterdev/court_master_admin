import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/schedule_bloc.dart';
import '../../bloc/schedule_event.dart';
import '../../bloc/schedule_state.dart';
import '../../utils/schedule_actions.dart';
import 'schedule_grid_view.dart';
import 'schedule_week_view.dart';

class ScheduleBody extends StatelessWidget {
  final ScheduleLoaded state;
  final bool isPastDate;

  const ScheduleBody({
    super.key,
    required this.state,
    required this.isPastDate,
  });

  @override
  Widget build(BuildContext context) {
    switch (state.viewType) {
      case ScheduleViewType.day:
        return ScheduleGridView(
          state: state,
          isPastDate: isPastDate,
          onEditCourt: (courtId, courtName) =>
              ScheduleActions.openEditCourtDialog(context, courtId, courtName),
          onTimeSlotTapped: (courtId, hour, minute) => isPastDate
              ? ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Нельзя изменять в прошлом')),
                )
              : ScheduleActions.openEventSheet(context, state, courtId, hour),
          onEventTapped: (event) => ScheduleActions.openEventSheet(
            context,
            state,
            event.courtId,
            event.startTime.hour,
            existingEvent: event,
          ),
        );
      case ScheduleViewType.week:
        return ScheduleWeekView(
          state: state,
          onTimeSlotTapped: (courtId, hour, minute, selectedDay) {
            context.read<ScheduleBloc>().add(
              LoadScheduleData(selectedDay, viewType: ScheduleViewType.week),
            );
            ScheduleActions.openEventSheet(
              context,
              state.copyWith(scheduleDate: selectedDay),
              courtId,
              hour,
            );
          },
          onEventTapped: (event) => ScheduleActions.openEventSheet(
            context,
            state,
            event.courtId,
            event.startTime.hour,
            existingEvent: event,
          ),
        );
      case ScheduleViewType.month:
        return const Center(
          child: Text(
            'Месячный вид в разработке.',
            style: TextStyle(color: Colors.grey),
          ),
        );
    }
  }
}
