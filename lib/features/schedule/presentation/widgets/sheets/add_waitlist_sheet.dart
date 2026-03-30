import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/waitlist_group_form.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/waitlist_type_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/waitlist/waitlist_bloc.dart';
import '../../bloc/waitlist/waitlist_event.dart';
import '../forms/schedule_time_picker_row.dart';

class AddWaitlistSheet extends StatefulWidget {
  final DateTime date;
  const AddWaitlistSheet({super.key, required this.date});

  @override
  State<AddWaitlistSheet> createState() => _AddWaitlistSheetState();
}

class _AddWaitlistSheetState extends State<AddWaitlistSheet> {
  String _type = 'RENTAL';
  TimeOfDay start = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay end = const TimeOfDay(hour: 19, minute: 0);

  final nameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final gameLevelCtrl = TextEditingController();
  final commentCtrl = TextEditingController();
  String? _ageGroup;

  @override
  void dispose() {
    nameCtrl.dispose();
    lastNameCtrl.dispose();
    phoneCtrl.dispose();
    gameLevelCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  String _fmtTime(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  void _submit() {
    final data = <String, dynamic>{
      'type': _type,
      'clientName': nameCtrl.text,
      'clientPhone': phoneCtrl.text,
    };

    if (_type == 'RENTAL') {
      data['date'] = widget.date.toIso8601String();
      data['startTime'] = _fmtTime(start);
      data['endTime'] = _fmtTime(end);
    } else {
      data['lastName'] = lastNameCtrl.text;
      data['gameLevel'] = gameLevelCtrl.text;
      if (_ageGroup != null) data['ageGroup'] = _ageGroup;
      data['comment'] = commentCtrl.text;
    }

    context.read<WaitlistBloc>().add(AddToWaitlist(data, widget.date));
    Navigator.pop(context);
  }

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
            const SizedBox(height: 16),
            WaitlistTypeSelector(
              selectedType: _type,
              onChanged: (val) => setState(() => _type = val),
            ),
            const SizedBox(height: 16),
            if (_type == 'RENTAL')
              ScheduleTimePickerRow(
                startTime: start,
                endTime: end,
                onStartTimeChanged: (t) => setState(() => start = t),
                onEndTimeChanged: (t) => setState(() => end = t),
              ),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Имя'),
            ),
            TextField(
              controller: phoneCtrl,
              decoration: const InputDecoration(labelText: 'Телефон'),
              keyboardType: TextInputType.phone,
            ),
            if (_type == 'GROUP')
              WaitlistGroupForm(
                lastNameCtrl: lastNameCtrl,
                gameLevelCtrl: gameLevelCtrl,
                commentCtrl: commentCtrl,
                selectedAge: _ageGroup,
                onAgeChanged: (val) => setState(() => _ageGroup = val),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: _submit,
              child: const Text('Добавить'),
            ),
          ],
        ),
      ),
    );
  }
}
