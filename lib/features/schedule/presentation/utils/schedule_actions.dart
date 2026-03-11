import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../data/models/schedule_event_model.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../bloc/event_attendance_bloc.dart';
import '../widgets/sheets/create_schedule_event_sheet.dart';
import '../widgets/sheets/event_attendance_sheet.dart';

class ScheduleActions {
  static void changeWeek(
    BuildContext context,
    DateTime current,
    int daysOffset,
  ) {
    context.read<ScheduleBloc>().add(
      LoadScheduleData(current.add(Duration(days: daysOffset))),
    );
  }

  static void openEventSheet(
    BuildContext context,
    ScheduleLoaded state,
    String courtId,
    int hour, {
    ScheduleEventModel? existingEvent,
  }) {
    if (existingEvent != null && existingEvent.eventType == 'group') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider(
          create: (context) => sl<EventAttendanceBloc>(),
          child: EventAttendanceSheet(
            eventId: existingEvent.id,
            groupName: 'Групповая тренировка',
          ),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => CreateScheduleEventSheet(
        courtId: courtId,
        startHour: hour,
        date: state.scheduleDate,
        groups: state.groups,
        coaches: state.coaches,
        existingEvent: existingEvent,
        onSave:
            ({
              required eventType,
              required startTime,
              required endTime,
              required color,
              clientName,
              clientPhone,
              coachId,
              groupId,
            }) {
              String formatTime(TimeOfDay t) =>
                  "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

              if (existingEvent == null) {
                context.read<ScheduleBloc>().add(
                  CreateScheduleEventRequested({
                    'type': eventType,
                    'date': state.scheduleDate.toIso8601String(),
                    'startTime': formatTime(startTime),
                    'endTime': formatTime(endTime),
                    'colorHex': color,
                    'courtId': courtId,
                    'groupId': groupId,
                    'clientName': clientName,
                    'clientPhone': clientPhone,
                    'coachId': coachId,
                  }),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Редактирование пока недоступно'),
                  ),
                );
              }
              Navigator.pop(ctx);
            },
      ),
    );
  }
}
