import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../widgets/views/schedule_body.dart';
import '../widgets/views/schedule_header.dart';
import '../widgets/views/schedule_week_view.dart';
import '../utils/schedule_actions.dart';
import '../widgets/dialogs/create_court_dialog.dart';

class AdminScheduleTab extends StatefulWidget {
  const AdminScheduleTab({super.key});

  @override
  State<AdminScheduleTab> createState() => _AdminScheduleTabState();
}

class _AdminScheduleTabState extends State<AdminScheduleTab> {
  String currentView = 'day';

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(LoadScheduleData(DateTime.now()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ScheduleError) {
          return Center(child: Text('Ошибка: ${state.message}'));
        }

        if (state is ScheduleLoaded) {
          final isPastDate = state.scheduleDate.isBefore(
            DateTime.now().subtract(const Duration(days: 1)),
          );

          return Column(
            children: [
              ScheduleHeader(
                date: state.scheduleDate,
                isPastDate: isPastDate,
                onCreateCourt: () {
                  showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<ScheduleBloc>(),
                      child: CreateCourtDialog(
                        onSave: (name) => context.read<ScheduleBloc>().add(
                          CreateCourtRequested(name),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'day', label: Text('День')),
                        ButtonSegment(value: 'week', label: Text('Неделя')),
                        ButtonSegment(value: 'month', label: Text('Месяц')),
                      ],
                      selected: {currentView},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          currentView = newSelection.first;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () => ScheduleActions.changeWeek(
                        context,
                        state.scheduleDate,
                        -1,
                      ),
                    ),
                    Text(
                      '${state.scheduleDate.day}.${state.scheduleDate.month}.${state.scheduleDate.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () => ScheduleActions.changeWeek(
                        context,
                        state.scheduleDate,
                        1,
                      ),
                    ),
                  ],
                ),
              ),
              if (currentView == 'day')
                ScheduleBody(
                  state: state,
                  isPastDate: isPastDate,
                  onEditCourt: (courtId, courtName) =>
                      ScheduleActions.openEditCourtDialog(
                        context,
                        courtId,
                        courtName,
                      ),
                  onTimeSlotTapped: (courtId, hour, minute) =>
                      ScheduleActions.openEventSheet(
                        context,
                        state,
                        courtId,
                        hour,
                      ),
                  onEventTapped: (event) => ScheduleActions.openEventSheet(
                    context,
                    state,
                    event.courtId,
                    event.startTime.hour,
                    existingEvent: event,
                  ),
                )
              else if (currentView == 'week')
                ScheduleWeekView(
                  state: state,
                  onTimeSlotTapped: (courtId, hour, minute, date) =>
                      ScheduleActions.openEventSheet(
                        context,
                        state,
                        courtId,
                        hour,
                      ),
                  onEventTapped: (event) => ScheduleActions.openEventSheet(
                    context,
                    state,
                    event.courtId,
                    event.startTime.hour,
                    existingEvent: event,
                  ),
                )
              else
                const Expanded(
                  child: Center(child: Text('Вид на месяц в разработке')),
                ),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
