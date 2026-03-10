import 'package:court_master_admin/features/schedule/presentation/widgets/schedule_color_picker_row.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/schedule_event_type_selector.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/schedule_group_form.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/schedule_rent_form.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/schedule_time_picker_row.dart';
import 'package:flutter/material.dart';
import '../../../groups/data/models/group_model.dart';
import '../../../employees/data/models/coach_model.dart';
import '../../data/models/schedule_event_model.dart';

class CreateScheduleEventSheet extends StatefulWidget {
  final String courtId;
  final int startHour;
  final DateTime date;
  final List<GroupModel> groups;
  final List<CoachModel> coaches;
  final ScheduleEventModel? existingEvent;

  final Function({
    required String eventType,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String color,
    String? groupId,
    String? clientName,
    String? clientPhone,
    String? coachId,
  })
  onSave;

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
  State<CreateScheduleEventSheet> createState() =>
      _CreateScheduleEventSheetState();
}

class _CreateScheduleEventSheetState extends State<CreateScheduleEventSheet> {
  late String eventType;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late String selectedColor;

  String? selectedGroupId;
  final clientNameController = TextEditingController();
  final clientPhoneController = TextEditingController();
  String? selectedCoachId;

  @override
  void initState() {
    super.initState();
    final ev = widget.existingEvent;
    if (ev != null) {
      eventType = ev.eventType;
      startTime = ev.startTime;
      endTime = ev.endTime;
      selectedColor = ev.color;
      if (eventType == 'group') {
        selectedGroupId = ev.groupId;
      } else {
        clientNameController.text = ev.clientName ?? '';
        clientPhoneController.text = ev.clientPhone ?? '';
        selectedCoachId = ev.coachId;
      }
    } else {
      eventType = 'group';
      startTime = TimeOfDay(hour: widget.startHour, minute: 0);
      endTime = TimeOfDay(hour: widget.startHour + 1, minute: 0);
      selectedColor = 'blue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Новая запись',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ScheduleTimePickerRow(
              startTime: startTime,
              endTime: endTime,
              onStartTimeChanged: (t) => setState(() => startTime = t),
              onEndTimeChanged: (t) => setState(() => endTime = t),
            ),
            const Divider(),
            ScheduleColorPickerRow(
              selectedColor: selectedColor,
              onColorSelected: (c) => setState(() => selectedColor = c),
            ),
            const Divider(),
            ScheduleEventTypeSelector(
              eventType: eventType,
              onTypeChanged: (t) => setState(() => eventType = t),
            ),
            const SizedBox(height: 16),
            if (eventType == 'group')
              ScheduleGroupForm(
                groups: widget.groups,
                selectedGroupId: selectedGroupId,
                onGroupSelected: (id) => setState(() => selectedGroupId = id),
              )
            else
              ScheduleRentForm(
                clientNameController: clientNameController,
                clientPhoneController: clientPhoneController,
                coaches: widget.coaches,
                selectedCoachId: selectedCoachId,
                onCoachSelected: (id) => setState(() => selectedCoachId = id),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => widget.onSave(
                eventType: eventType,
                startTime: startTime,
                endTime: endTime,
                color: selectedColor,
                groupId: selectedGroupId,
                clientName: clientNameController.text,
                clientPhone: clientPhoneController.text,
                coachId: selectedCoachId,
              ),
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
