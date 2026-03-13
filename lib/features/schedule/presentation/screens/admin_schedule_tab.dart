import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../utils/schedule_actions.dart';
import '../widgets/views/schedule_header.dart';
import '../widgets/views/weekly_calendar.dart';
import '../widgets/views/schedule_body.dart';

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
              style: const TextStyle(color: Colors.red),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SegmentedButton<ScheduleViewType>(
                  segments: const [
                    ButtonSegment(
                      value: ScheduleViewType.day,
                      label: Text('День'),
                    ),
                    ButtonSegment(
                      value: ScheduleViewType.week,
                      label: Text('Неделя'),
                    ),
                    ButtonSegment(
                      value: ScheduleViewType.month,
                      label: Text('Месяц'),
                    ),
                  ],
                  selected: {state.viewType},
                  onSelectionChanged: (newSelection) => context
                      .read<ScheduleBloc>()
                      .add(ChangeScheduleViewTypeRequested(newSelection.first)),
                ),
              ),
              Expanded(
                child: ScheduleBody(state: state, isPastDate: isPastDate),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
