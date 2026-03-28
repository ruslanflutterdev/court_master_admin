import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../schedule/presentation/bloc/schedule_bloc.dart';
import '../../../schedule/presentation/bloc/schedule_event.dart';
import '../../../schedule/presentation/bloc/schedule_state.dart';

class SidebarCalendar extends StatelessWidget {
  const SidebarCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoaded) {
          return SizedBox(
            width: 250, // Фиксируем ширину для предотвращения ошибок верстки
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.green),
              ),
              child: CalendarDatePicker(
                initialDate: state.scheduleDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (date) =>
                    context.read<ScheduleBloc>().add(LoadScheduleData(date)),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
