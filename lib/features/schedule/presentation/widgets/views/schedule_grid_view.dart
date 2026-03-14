import 'package:flutter/material.dart';
import '../../../../schedule/data/models/schedule_event_model.dart';
import '../../bloc/schedule_state.dart';
import '../cards/schedule_event_card.dart';

class ScheduleGridView extends StatelessWidget {
  final ScheduleLoaded state;
  final bool isPastDate;
  final Function(String courtId, String courtName) onEditCourt;
  final Function(String courtId, int hour, int minute) onTimeSlotTapped;
  final Function(ScheduleEventModel event) onEventTapped;

  const ScheduleGridView({
    super.key,
    required this.state,
    required this.isPastDate,
    required this.onEditCourt,
    required this.onTimeSlotTapped,
    required this.onEventTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (state.courts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Создайте первый корт, нажав на кнопку "+ Корт"'),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: state.courts.map((court) {
        final courtEvents = state.scheduleEvents
            .where((e) => e.courtId == court.id)
            .toList();

        return Container(
          width: 150,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey.shade300),
              right: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        court.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isPastDate)
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.blue,
                        ),
                        onPressed: () => onEditCourt(court.id, court.name),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),

              SizedBox(
                height: 18 * 80.0,
                child: Stack(
                  children: [
                    Column(
                      children: List.generate(36, (index) {
                        final hour = 6 + (index ~/ 2);
                        final minute = (index % 2) == 0 ? 0 : 30;

                        return GestureDetector(
                          onTap: () => onTimeSlotTapped(court.id, hour, minute),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: minute == 30
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade100,
                                  width: minute == 30 ? 1 : 0.5,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    ...courtEvents.map(
                      (e) => ScheduleEventCard(
                        event: e,
                        isPastDate: isPastDate,
                        onTap: () => onEventTapped(e),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
