import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/presentation/widgets/primary_button.dart';
import '../../../../clients/data/models/client_model.dart';
import '../../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../../clients/presentation/bloc/clients_state.dart';
import '../../../../groups/data/models/group_model.dart';
import '../../../../groups/presentation/bloc/groups_bloc.dart';
import '../../../../groups/presentation/bloc/groups_state.dart';
import '../../../data/models/court_model.dart';
import '../../bloc/schedule/schedule_bloc.dart';
import '../../bloc/schedule/schedule_event.dart';
import '../../bloc/schedule/schedule_state.dart';
import '../../utils/time_picker_utils.dart';
import '../forms/schedule_color_picker_row.dart';
import '../forms/schedule_dynamic_form_section.dart';
import '../forms/schedule_recurrence_form.dart';
import 'create_event_time_row.dart';
import 'event_court_selector.dart';
import 'event_type_selector.dart';

class CreateScheduleEventSheet extends StatefulWidget {
  final DateTime initialDate;
  final int startHour;
  final List<GroupModel> groups;
  final String? initialCourtId;

  const CreateScheduleEventSheet({
    super.key,
    required this.initialDate,
    required this.startHour,
    required this.groups,
    this.initialCourtId,
  });

  @override
  State<CreateScheduleEventSheet> createState() =>
      _CreateScheduleEventSheetState();
}

class _CreateScheduleEventSheetState extends State<CreateScheduleEventSheet> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  late TimeOfDay _start, _end;
  String _type = 'rent';
  String? _courtId, _groupId;
  String _colorHex = '#2196F3';
  bool _isRecurring = false;
  int _recurrenceWeeks = 4;

  @override
  void initState() {
    super.initState();
    _start = TimeOfDay(hour: widget.startHour, minute: 0);
    _end = TimeOfDay(hour: widget.startHour + 1, minute: 0);
    _courtId = widget.initialCourtId;
  }

  void _onTypeChanged(String? v) => setState(() => _type = v ?? 'rent');

  Future<void> _pickStart() async {
    final t = await TimePickerUtils.pick24hTime(
      context: context,
      initialTime: _start,
    );
    if (t != null) setState(() => _start = t);
  }

  Future<void> _pickEnd() async {
    final t = await TimePickerUtils.pick24hTime(
      context: context,
      initialTime: _end,
    );
    if (t != null) setState(() => _end = t);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'type': _type,
      'date': widget.initialDate.toIso8601String(),
      'startTime':
          '${_start.hour.toString().padLeft(2, '0')}:${_start.minute.toString().padLeft(2, '0')}',
      'endTime':
          '${_end.hour.toString().padLeft(2, '0')}:${_end.minute.toString().padLeft(2, '0')}',
      'courtId': _courtId,
      'groupId': _groupId,
      'colorHex': _colorHex,
      'clientName': '${_firstCtrl.text} ${_lastCtrl.text}'.trim(),
      'clientPhone': _phoneCtrl.text,
      'isRecurring': _isRecurring,
      if (_isRecurring) 'recurrenceWeeks': _recurrenceWeeks,
    };

    context.read<ScheduleBloc>().add(CreateScheduleEventRequested(data));
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ScheduleBloc>().state;
    final clientsState = context.watch<ClientsBloc>().state;
    final groupsState = context.watch<GroupsBloc>().state;
    final List<CourtModel> courts = state is ScheduleLoaded ? state.courts : [];
    final allClients = clientsState is ClientsLoaded
        ? clientsState.clients
        : <ClientModel>[];
    final currentGroups = groupsState is GroupsLoaded
        ? groupsState.groups
        : <GroupModel>[];

    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Новое событие',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 24),
              EventTypeSelector(selectedType: _type, onChanged: _onTypeChanged),
              CreateEventTimeRow(
                start: _start,
                end: _end,
                onSelectStart: _pickStart,
                onSelectEnd: _pickEnd,
              ),
              const SizedBox(height: 24),
              EventCourtSelector(
                selectedCourtId: _courtId,
                courts: courts,
                onChanged: (v) => setState(() => _courtId = v),
              ),
              const SizedBox(height: 16),
              ScheduleColorPickerRow(
                selectedColor: _colorHex,
                onColorSelected: (color) {
                  setState(() {
                    _colorHex = color;
                  });
                },
              ),
              const SizedBox(height: 16),
              ScheduleDynamicFormSection(
                type: _type,
                groups: currentGroups,
                selectedGroupId: _groupId,
                onGroupSelected: (v) => setState(() => _groupId = v),
                firstNameController: _firstCtrl,
                lastNameController: _lastCtrl,
                phoneController: _phoneCtrl,
                allClients: allClients,
              ),
              const Divider(height: 32),
              ScheduleRecurrenceForm(
                isRecurring: _isRecurring,
                recurrenceWeeks: _recurrenceWeeks,
                onRecurringChanged: (val) => setState(() => _isRecurring = val),
                onWeeksChanged: (val) => setState(() => _recurrenceWeeks = val),
              ),
              const SizedBox(height: 24),
              PrimaryButton(text: 'Создать', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
