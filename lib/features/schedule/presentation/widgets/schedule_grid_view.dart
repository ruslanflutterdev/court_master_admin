import 'package:court_master_admin/features/schedule/presentation/widgets/schedule_event_card.dart';
import 'package:flutter/material.dart';
import '../bloc/schedule_bloc.dart';
import '../../data/models/schedule_event_model.dart';

class ScheduleGridView extends StatelessWidget {
  final ScheduleLoaded state;
  final bool isPastDate;
  final Function(String courtId, String courtName) onEditCourt;
  final Function(String courtId, int hour) onTimeSlotTapped;
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
      return const Center(child: Text('Создайте первый корт'));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 40),
                ...List.generate(
                  18,
                  (index) => Container(
                    height: 80,
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(right: 8, top: 4),
                    child: Text(
                      '${index + 6}:00',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Row(
                children: state.courts.map((court) {
                  final courtEvents = state.scheduleEvents
                      .where((e) => e.courtId == court.id)
                      .toList();

                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          alignment: Alignment.center,
                          color: Colors.green.shade50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                court.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!isPastDate)
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 14),
                                  onPressed: () =>
                                      onEditCourt(court.id, court.name),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 18 * 80.0,
                          child: Stack(
                            children: [
                              Column(
                                children: List.generate(
                                  18,
                                  (index) => GestureDetector(
                                    onTap: () =>
                                        onTimeSlotTapped(court.id, index + 6),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
