import 'package:flutter/material.dart';
import '../forms/schedule_time_picker_row.dart';
import '../forms/schedule_color_picker_row.dart';
import '../forms/schedule_event_type_selector.dart';
import '../forms/schedule_dynamic_form_section.dart';
import '../forms/schedule_recurrence_form.dart';
import '../forms/schedule_price_display.dart';
import '../forms/schedule_save_button.dart';
import '../forms/schedule_form_types.dart';
import '../../../data/models/schedule_event_model.dart';
import '../../../../groups/data/models/group_model.dart';
import '../../../../employees/data/models/coach_model.dart';

class CreateScheduleEventSheet extends StatefulWidget {
  final String courtId;
  final int startHour;
  final DateTime date;
  final List<GroupModel> groups;
  final List<CoachModel> coaches;
  final ScheduleEventModel? existingEvent;
  final OnSaveEvent onSave;

  const CreateScheduleEventSheet({
    super.key,
    required this.courtId,
    required this.startHour,
    required this.date,
    required this.groups,
    required this.coaches,
    this.existingEvent,
    required this.onSave,
  });

  @override
  State<CreateScheduleEventSheet> createState() => _SheetState();
}

class _SheetState extends State<CreateScheduleEventSheet> {
  late String type, color;
  late TimeOfDay start, end;
  bool isRecurring = false;
  int recurrenceWeeks = 1;
  String? groupId, coachId;
  final clientName = TextEditingController(),
      clientPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    final ev = widget.existingEvent;
    type = ev?.eventType ?? 'group';
    start = ev?.startTime ?? TimeOfDay(hour: widget.startHour, minute: 0);
    end = ev?.endTime ?? TimeOfDay(hour: widget.startHour + 1, minute: 0);
    color = ev?.colorHex ?? '#2196F3';
    if (ev != null && ev.eventType == 'group') groupId = ev.groupId;
    if (ev != null && ev.eventType != 'group') {
      clientName.text = ev.clientName ?? '';
      clientPhone.text = ev.clientPhone ?? '';
      coachId = ev.coachId;
    }
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
              'Новая запись',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ScheduleTimePickerRow(
              startTime: start,
              endTime: end,
              onStartTimeChanged: (t) => setState(() => start = t),
              onEndTimeChanged: (t) => setState(() => end = t),
            ),
            ScheduleColorPickerRow(
              selectedColor: color,
              onColorSelected: (c) => setState(() => color = c),
            ),
            ScheduleEventTypeSelector(
              selectedType: type,
              onChanged: (t) => setState(() => type = t),
            ),
            ScheduleDynamicFormSection(
              type: type,
              groups: widget.groups,
              selectedGroupId: groupId,
              onGroupSelected: (id) => setState(() => groupId = id),
              coaches: widget.coaches,
              selectedCoachId: coachId,
              onCoachSelected: (id) => setState(() => coachId = id),
              clientNameController: clientName,
              clientPhoneController: clientPhone,
            ),
            if (widget.existingEvent == null)
              ScheduleRecurrenceForm(
                isRecurring: isRecurring,
                recurrenceWeeks: recurrenceWeeks,
                onRecurringChanged: (v) => setState(() => isRecurring = v),
                onWeeksChanged: (v) => setState(() => recurrenceWeeks = v),
              ),
            const SchedulePriceDisplay(),
            const SizedBox(height: 16),
            ScheduleSaveButton(
              onPressed: () => widget.onSave(
                type: type,
                start: start,
                end: end,
                color: color,
                isRecurring: isRecurring,
                weeks: recurrenceWeeks,
                groupId: groupId,
                clientName: clientName.text,
                clientPhone: clientPhone.text,
                coachId: coachId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
