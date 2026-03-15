import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/waitlist_bloc.dart';
import '../../bloc/waitlist_event.dart';
import '../forms/schedule_time_picker_row.dart';

class AddWaitlistSheet extends StatefulWidget {
  final DateTime date;
  const AddWaitlistSheet({super.key, required this.date});

  @override
  State<AddWaitlistSheet> createState() => _AddWaitlistSheetState();
}

class _AddWaitlistSheetState extends State<AddWaitlistSheet> {
  TimeOfDay start = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 19, minute: 0);
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Записать в резерв',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ScheduleTimePickerRow(
              startTime: start,
              endTime: end,
              onStartTimeChanged: (t) => setState(() => start = t),
              onEndTimeChanged: (t) => setState(() => end = t),
            ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Имя клиента'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Телефон'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                String fmt(TimeOfDay t) =>
                    "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";
                context.read<WaitlistBloc>().add(
                  AddToWaitlist({
                    'date': widget.date.toIso8601String(),
                    'startTime': fmt(start),
                    'endTime': fmt(end),
                    'clientName': nameCtrl.text,
                    'clientPhone': phoneCtrl.text,
                  }, widget.date),
                );
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
