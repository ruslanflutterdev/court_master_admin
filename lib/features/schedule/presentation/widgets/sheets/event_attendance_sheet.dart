import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event_attendance_bloc.dart';
import '../../bloc/event_attendance_event.dart';
import '../../bloc/event_attendance_state.dart';

class EventAttendanceSheet extends StatefulWidget {
  final String eventId;
  final String groupName; // Чтобы красиво вывести название группы в шапке

  const EventAttendanceSheet({
    super.key,
    required this.eventId,
    required this.groupName,
  });

  @override
  State<EventAttendanceSheet> createState() => _EventAttendanceSheetState();
}

class _EventAttendanceSheetState extends State<EventAttendanceSheet> {
  @override
  void initState() {
    super.initState();
    // При открытии шторки сразу загружаем список учеников
    context.read<EventAttendanceBloc>().add(
      LoadAttendanceEvent(widget.eventId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      // Ограничиваем высоту шторки, чтобы она не была на весь экран, но скроллилась
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Журнал: ${widget.groupName}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: BlocBuilder<EventAttendanceBloc, EventAttendanceState>(
              builder: (context, state) {
                if (state is EventAttendanceLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EventAttendanceError) {
                  return Center(
                    child: Text(
                      'Ошибка: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is EventAttendanceLoaded) {
                  final students = state.students;

                  if (students.isEmpty) {
                    return const Center(
                      child: Text('В этой группе пока нет учеников.'),
                    );
                  }

                  return ListView.separated(
                    itemCount: students.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      // Определяем текущий статус: если еще не отмечали, будет null
                      final currentStatus = student.attendanceStatus;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${student.firstName} ${student.lastName}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Баланс: ${student.balance}',
                                  style: TextStyle(
                                    color: student.balance >= 0
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Переключатель статуса
                            SegmentedButton<int>(
                              segments: const [
                                ButtonSegment(
                                  value: 1,
                                  label: Text(
                                    'Был',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                ButtonSegment(
                                  value: 2,
                                  label: Text(
                                    'Не был',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                ButtonSegment(
                                  value: 3,
                                  label: Text(
                                    'Болел',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                              // Если статус null (еще не отмечали), ничего не выбрано
                              selected: currentStatus != null
                                  ? {currentStatus}
                                  : <int>{},
                              emptySelectionAllowed:
                                  true, // Разрешаем, чтобы изначально ничего не было выбрано
                              onSelectionChanged: (Set<int> newSelection) {
                                if (newSelection.isNotEmpty) {
                                  context.read<EventAttendanceBloc>().add(
                                    MarkStudentEvent(
                                      widget.eventId,
                                      student.id,
                                      newSelection.first,
                                    ),
                                  );
                                }
                              },
                              style: SegmentedButton.styleFrom(
                                selectedBackgroundColor: currentStatus == 1
                                    ? Colors.green.shade100
                                    : (currentStatus == 2
                                          ? Colors.red.shade100
                                          : Colors.orange.shade100),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
