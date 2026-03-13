import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../clients/data/models/client_attendance_model.dart';
import 'attendance_status_icon.dart';

class ClientAttendanceList extends StatelessWidget {
  final List<ClientAttendanceModel> attendances;

  const ClientAttendanceList({super.key, required this.attendances});

  @override
  Widget build(BuildContext context) {
    if (attendances.isEmpty) {
      return const Center(
        child: Text(
          'Нет истории посещений',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: attendances.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, index) {
        final attendance = attendances[index];
        final event = attendance.event;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            leading: AttendanceStatusIcon(status: attendance.status),
            title: Text(
              '${event.eventType == "rent" ? "Аренда" : "Группа"} | ${event.courtName ?? "Корт неизвестен"}',
            ),
            subtitle: Text(
              '${DateFormat('dd.MM.yyyy').format(event.date)} в ${event.startTime.format(context)}\nТренер: ${event.coachFullName ?? "Не назначен"}',
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
