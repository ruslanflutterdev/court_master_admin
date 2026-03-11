import 'package:flutter/material.dart';
import '../../../data/models/schedule_event_model.dart';
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
      return const Center(child: Text('Создайте первый корт'));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Левая колонка со временем (каждые 30 минут)
        SizedBox(
          width: 60,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 40), // Отступ под шапку корта
                ...List.generate(
                  34, // С 6:00 до 22:30 = 34 слота по 30 минут
                  (index) {
                    final hour = 6 + (index ~/ 2);
                    final minute = (index % 2) == 0 ? '00' : '30';
                    return Container(
                      height: 40, // 40 пикселей на полчаса (80 пикселей в час)
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 8, top: 4),
                      child: Text(
                        '$hour:$minute',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Сетка кортов
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
                        // Шапка корта
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
                        // Сама сетка для одного корта
                        SizedBox(
                          height: 34 * 40.0, // Общая высота: 34 слота по 40px
                          child: Stack(
                            children: [
                              Column(
                                children: List.generate(34, (index) {
                                  final hour = 6 + (index ~/ 2);
                                  final minute = (index % 2) == 0 ? 0 : 30;
                                  return GestureDetector(
                                    onTap: () => onTimeSlotTapped(
                                      court.id,
                                      hour,
                                      minute,
                                    ),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              // Отрисовка карточек событий поверх сетки
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
