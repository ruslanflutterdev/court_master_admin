import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event_attendance_bloc.dart';
import '../../bloc/event_attendance_event.dart';
import '../../bloc/event_attendance_state.dart';

class EventAttendanceSheet extends StatefulWidget {
  final String eventId;
  final String groupName;

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
            child: BlocConsumer<EventAttendanceBloc, EventAttendanceState>(
              listener: (context, state) {
                if (state is EventAttendanceLoaded &&
                    state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.white),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.red.shade800,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        left: 16,
                        right: 16,
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
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
                                  '${student.firstName} ${student.lastName ?? ''}'
                                      .trim(),
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
                              selected: currentStatus != null
                                  ? {currentStatus}
                                  : <int>{},
                              emptySelectionAllowed: true,
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
