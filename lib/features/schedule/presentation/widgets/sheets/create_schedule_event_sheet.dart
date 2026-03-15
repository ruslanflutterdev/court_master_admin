import 'package:flutter/material.dart';
import '../../../../employees/data/models/coach_model.dart';
import '../../../../groups/data/models/group_model.dart';
import '../../../data/models/schedule_event_model.dart';
import '../forms/schedule_event_type_selector.dart';
import '../forms/schedule_dynamic_form_section.dart';
import '../forms/schedule_time_picker_row.dart';
import '../forms/schedule_color_picker_row.dart';
import '../forms/schedule_recurrence_form.dart';
import '../forms/schedule_price_display.dart';
import '../forms/schedule_save_button.dart';

class CreateScheduleEventSheet extends StatefulWidget {
  final String courtId;
  final int startHour;
  final DateTime date;
  final List<GroupModel> groups;
  final List<CoachModel> coaches;
  final ScheduleEventModel? existingEvent;

  final Function({
    required String type,
    required TimeOfDay start,
    required TimeOfDay end,
    required String color,
    required bool isRecurring,
    required int weeks,
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
  late String selectedType;
  late TimeOfDay startTime;
  late TimeOfDay endTime;
  late String colorHex;

  String? selectedGroupId;
  String? selectedCoachId;

  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();

  bool isRecurring = false;
  int recurrenceWeeks = 1;

  bool get isEditMode => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();

    if (isEditMode) {
      final e = widget.existingEvent!;
      selectedType = e.eventType;
      startTime = e.startTime;
      endTime = e.endTime;
      colorHex = e.colorHex;
      selectedGroupId = e.groupId;
      selectedCoachId = e.coachId;
      _clientNameController.text = e.clientName ?? '';
      _clientPhoneController.text = e.clientPhone ?? '';
    } else {
      selectedType = 'rent';
      startTime = TimeOfDay(hour: widget.startHour, minute: 0);
      endTime = TimeOfDay(hour: widget.startHour + 1, minute: 0);
      colorHex = 'blue';
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    super.dispose();
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? 'Редактировать событие' : 'Новая запись',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            IgnorePointer(
              ignoring: isEditMode,
              child: Opacity(
                opacity: isEditMode ? 0.6 : 1.0,
                child: ScheduleEventTypeSelector(
                  selectedType: selectedType,
                  onChanged: (val) => setState(
                    () => selectedType = val,
                  ), // ИСПРАВЛЕНИЕ параметра
                ),
              ),
            ),
            const SizedBox(height: 16),

            ScheduleTimePickerRow(
              startTime: startTime,
              endTime: endTime,
              onStartTimeChanged: (val) => setState(() => startTime = val),
              onEndTimeChanged: (val) => setState(() => endTime = val),
            ),
            const SizedBox(height: 16),

            ScheduleDynamicFormSection(
              type: selectedType,
              groups: widget.groups,
              coaches: widget.coaches,
              selectedGroupId: selectedGroupId,
              clientNameController: _clientNameController,
              clientPhoneController: _clientPhoneController,
              selectedCoachId: selectedCoachId,
              onGroupSelected: (val) => setState(() => selectedGroupId = val),
              onCoachSelected: (val) => setState(() => selectedCoachId = val),
            ),
            const SizedBox(height: 16),

            ScheduleColorPickerRow(
              selectedColor: colorHex,
              onColorSelected: (val) => setState(() => colorHex = val),
            ),
            const SizedBox(height: 16),

            if (!isEditMode) ...[
              ScheduleRecurrenceForm(
                isRecurring: isRecurring,
                recurrenceWeeks: recurrenceWeeks,
                onRecurringChanged: (val) => setState(() => isRecurring = val),
                onWeeksChanged: (val) => setState(() => recurrenceWeeks = val),
              ),
              const SizedBox(height: 16),
            ],

            const SchedulePriceDisplay(),
            const SizedBox(height: 16),

            ScheduleSaveButton(
              text: isEditMode ? 'Сохранить изменения' : 'Создать запись',
              onPressed: () {
                widget.onSave(
                  type: selectedType,
                  start: startTime,
                  end: endTime,
                  color: colorHex,
                  isRecurring: isRecurring,
                  weeks: recurrenceWeeks,
                  groupId: selectedGroupId,
                  clientName: _clientNameController.text.isNotEmpty
                      ? _clientNameController.text
                      : null,
                  clientPhone: _clientPhoneController.text.isNotEmpty
                      ? _clientPhoneController.text
                      : null,
                  coachId: selectedCoachId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
