import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../data/models/schedule_event_model.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../bloc/event_attendance_bloc.dart';
import '../widgets/dialogs/create_court_dialog.dart';
import '../widgets/sheets/create_schedule_event_sheet.dart';
import '../widgets/sheets/event_attendance_sheet.dart';

class ScheduleActions {
  static void openEditCourtDialog(
    BuildContext context,
    String id,
    String name,
  ) {
    final scheduleBloc = context.read<ScheduleBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: scheduleBloc,
        child: CreateCourtDialog(
          initialName: name,
          onSave: (newName) =>
              scheduleBloc.add(UpdateCourtRequested(id, newName)),
        ),
      ),
    );
  }

  static void changeWeek(BuildContext ctx, DateTime cur, int offset) {
    ctx.read<ScheduleBloc>().add(
      LoadScheduleData(cur.add(Duration(days: offset))),
    );
  }

  static void openEventSheet(
    BuildContext context,
    ScheduleLoaded state,
    String courtId,
    int hour, {
    ScheduleEventModel? existingEvent,
  }) {
    final scheduleBloc = context.read<ScheduleBloc>();

    if (existingEvent != null && existingEvent.eventType == 'group') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider(
          create: (_) => sl<EventAttendanceBloc>(),
          child: EventAttendanceSheet(
            eventId: existingEvent.id,
            groupName: 'Группа',
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
              required type,
              required start,
              required end,
              required color,
              required isRecurring,
              required weeks,
              groupId,
              clientName,
              clientPhone,
              coachId,
            }) {
              String fmt(TimeOfDay t) =>
                  "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
              if (existingEvent == null) {
                scheduleBloc.add(
                  CreateScheduleEventRequested({
                    'type': type,
                    'date': state.scheduleDate.toIso8601String(),
                    'startTime': fmt(start),
                    'endTime': fmt(end),
                    'colorHex': color,
                    'courtId': courtId,
                    'groupId': groupId,
                    'clientName': clientName,
                    'clientPhone': clientPhone,
                    'coachId': coachId,
                    'isRecurring': isRecurring,
                    'recurrenceWeeks': weeks,
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
