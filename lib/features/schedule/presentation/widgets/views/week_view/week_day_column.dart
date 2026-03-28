import 'package:flutter/material.dart';
import '../../../../data/models/schedule_event_model.dart';
import '../../cards/schedule_event_card.dart';

class WeekDayColumn extends StatelessWidget {
  final DateTime date;
  final String dayName;
  final List<ScheduleEventModel> dayEvents;
  final String selectedCourtId;
  final Function(String, int, int, DateTime) onTimeSlotTapped;
  final Function(ScheduleEventModel) onEventTapped;

  const WeekDayColumn({
    super.key,
    required this.date,
    required this.dayName,
    required this.dayEvents,
    required this.selectedCourtId,
    required this.onTimeSlotTapped,
    required this.onEventTapped,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPastDate = date.isBefore(DateTime(now.year, now.month, now.day));
    final isToday = date.day == now.day && date.month == now.month;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Container(
            height: 40,
            alignment: Alignment.center,
            color: isToday ? Colors.blue.shade50 : Colors.grey.shade50,
            child: Text(
              '$dayName, ${date.day}.${date.month}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 34 * 40.0,
            child: Stack(
              children: [
                Column(
                  children: List.generate(34, (index) {
                    final hour = 6 + (index ~/ 2);
                    final minute = (index % 2) == 0 ? 0 : 30;
                    return GestureDetector(
                      onTap: () => isPastDate
                          ? null
                          : onTimeSlotTapped(
                              selectedCourtId,
                              hour,
                              minute,
                              date,
                            ),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                          color: isPastDate ? Colors.grey.shade100 : null,
                        ),
                      ),
                    );
                  }),
                ),
                ...dayEvents.map(
                  (e) => ScheduleEventCard(
                    event: e,
                    isPastDate: isPastDate,
                    onTap: () => onEventTapped(e),
                    allEvents: dayEvents,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
