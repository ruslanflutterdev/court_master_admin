import 'package:flutter/material.dart';
import '../../../data/models/schedule_event_model.dart';
import '../../bloc/schedule_state.dart';
import '../../utils/schedule_date_helper.dart';
import 'common/time_column.dart';
import 'week_view/week_court_selector.dart';
import 'week_view/week_day_column.dart';

class ScheduleWeekView extends StatefulWidget {
  final ScheduleLoaded state;
  final Function(String, int, int, DateTime) onTimeSlotTapped;
  final Function(ScheduleEventModel) onEventTapped;

  const ScheduleWeekView({
    super.key,
    required this.state,
    required this.onTimeSlotTapped,
    required this.onEventTapped,
  });

  @override
  State<ScheduleWeekView> createState() => _ScheduleWeekViewState();
}

class _ScheduleWeekViewState extends State<ScheduleWeekView> {
  String? _selectedCourtId;

  @override
  void initState() {
    super.initState();
    if (widget.state.courts.isNotEmpty) {
      _selectedCourtId = widget.state.courts.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.courts.isEmpty) {
      return const Center(child: Text('Создайте первый корт'));
    }
    if (_selectedCourtId != null &&
        !widget.state.courts.any((c) => c.id == _selectedCourtId)) {
      _selectedCourtId = widget.state.courts.first.id;
    }

    final startOfWeek = ScheduleDateHelper.getDateRange(
      widget.state.scheduleDate,
      ScheduleViewType.week,
    )['start']!;
    final weekDays = List.generate(
      7,
      (index) => startOfWeek.add(Duration(days: index)),
    );
    final dayNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WeekCourtSelector(
          courts: widget.state.courts,
          selectedCourtId: _selectedCourtId,
          onChanged: (val) => setState(() => _selectedCourtId = val),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TimeColumn(), // Переиспользуемый виджет!
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Row(
                      children: weekDays.asMap().entries.map((entry) {
                        final currentDay = entry.value;
                        final dayEvents = widget.state.scheduleEvents
                            .where(
                              (e) =>
                                  e.courtId == _selectedCourtId &&
                                  e.date.year == currentDay.year &&
                                  e.date.month == currentDay.month &&
                                  e.date.day == currentDay.day,
                            )
                            .toList();

                        return WeekDayColumn(
                          date: currentDay,
                          dayName: dayNames[entry.key],
                          dayEvents: dayEvents,
                          selectedCourtId: _selectedCourtId!,
                          onTimeSlotTapped: widget.onTimeSlotTapped,
                          onEventTapped: widget.onEventTapped,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
