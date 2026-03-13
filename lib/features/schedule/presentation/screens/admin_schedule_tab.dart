import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../utils/schedule_actions.dart';
import '../widgets/views/schedule_header.dart';
import '../widgets/views/weekly_calendar.dart';
import '../widgets/views/schedule_grid_view.dart';
import '../widgets/dialogs/create_court_dialog.dart';

class AdminScheduleTab extends StatelessWidget {
  const AdminScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleError) {
          return Center(
            child: Text(
              'Ошибка: ${state.message}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ScheduleLoaded) {
          final now = DateTime.now();
          final isPastDate = DateTime(
            state.scheduleDate.year,
            state.scheduleDate.month,
            state.scheduleDate.day,
          ).isBefore(DateTime(now.year, now.month, now.day));

          return Column(
            children: [
              if (!isDesktop) ...[
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: WeeklyCalendar(
                    selectedDate: state.scheduleDate,
                    onDateSelected: (date) => context.read<ScheduleBloc>().add(
                      LoadScheduleData(date),
                    ),
                    onWeekChanged: (offset) => ScheduleActions.changeWeek(
                      context,
                      state.scheduleDate,
                      offset,
                    ),
                  ),
                ),
                const Divider(height: 1),
              ],

              ScheduleHeader(isPastDate: isPastDate),

              Expanded(
                child: ScheduleGridView(
                  state: state,
                  isPastDate: isPastDate,
                  onEditCourt: (courtId, courtName) => showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<ScheduleBloc>(),
                      child: CreateCourtDialog(
                        initialName: courtName,
                        onSave: (newName) => context.read<ScheduleBloc>().add(
                          UpdateCourtRequested(courtId, newName),
                        ),
                      ),
                    ),
                  ),
                  onTimeSlotTapped: (courtId, hour, minute) => isPastDate
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Нельзя изменять в прошлом'),
                          ),
                        )
                      : ScheduleActions.openEventSheet(
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
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
