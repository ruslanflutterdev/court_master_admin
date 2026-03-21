import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../groups/data/models/group_model.dart';
import '../../../groups/presentation/bloc/groups_bloc.dart';
import '../../../groups/presentation/bloc/groups_event.dart';
import '../../../groups/presentation/bloc/groups_state.dart';
import '../../data/models/schedule_event_model.dart';
import '../bloc/event_attendance_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/dialogs/create_court_dialog.dart';
import '../widgets/sheets/create_schedule_event_sheet.dart';
import '../widgets/sheets/event_attendance_sheet.dart';

class ScheduleActions {
  static void openEditCourtDialog(
    BuildContext context,
    String id,
    String name,
  ) {
    final bloc = context.read<ScheduleBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: CreateCourtDialog(
          initialName: name,
          onSave: (newName) => bloc.add(UpdateCourtRequested(id, newName)),
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
    final clientsBloc = context.read<ClientsBloc>();
    final groupsBloc = context.read<GroupsBloc>();

    // 1. Проверяем состояние групп. Если не загружены — инициируем загрузку.
    if (groupsBloc.state is! GroupsLoaded) {
      groupsBloc.add(
        LoadGroupsEvent(),
      ); // Используем правильное имя события из вашего GroupsBloc
    }

    if (existingEvent?.eventType == 'group') {
      _openAttendanceSheet(context, existingEvent!.id);
      return;
    }

    final groupsState = groupsBloc.state;
    final groups = groupsState is GroupsLoaded
        ? groupsState.groups
        : <GroupModel>[];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: scheduleBloc),
          BlocProvider.value(value: clientsBloc),
          BlocProvider.value(value: groupsBloc),
        ],
        child: CreateScheduleEventSheet(
          initialDate: state.scheduleDate,
          startHour: hour,
          groups: groups,
          initialCourtId: courtId,
        ),
      ),
    );
  }

  static void _openAttendanceSheet(BuildContext context, String eventId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<EventAttendanceBloc>(),
        child: EventAttendanceSheet(eventId: eventId, groupName: 'Группа'),
      ),
    );
  }
}
