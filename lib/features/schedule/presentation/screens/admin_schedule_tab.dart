import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/event_attendance_bloc.dart';
import '../bloc/schedule_bloc.dart';
import '../../data/models/schedule_event_model.dart';
import '../widgets/create_court_dialog.dart';
import '../widgets/create_schedule_event_sheet.dart';
import '../widgets/event_attendance_sheet.dart';
import '../widgets/weekly_calendar.dart';
import '../widgets/schedule_grid_view.dart';
import '../../../../core/di/dependencies_container.dart';

class AdminScheduleTab extends StatelessWidget {
  const AdminScheduleTab({super.key});

  void _changeWeek(BuildContext context, DateTime current, int daysOffset) {
    context.read<ScheduleBloc>().add(
      LoadScheduleData(current.add(Duration(days: daysOffset))),
    );
  }

  void _openEventSheet(
    BuildContext context,
    ScheduleLoaded state,
    String courtId,
    int hour, {
    ScheduleEventModel? existingEvent,
  }) {
    // ЕСЛИ ЭТО СУЩЕСТВУЮЩЕЕ ГРУППОВОЕ ЗАНЯТИЕ -> ОТКРЫВАЕМ ЖУРНАЛ
    if (existingEvent != null && existingEvent.eventType == 'group') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider(
          // Здесь мы создаем новый EventAttendanceBloc специально для этой шторки
          create: (context) => sl<EventAttendanceBloc>(),
          child: EventAttendanceSheet(
            eventId: existingEvent.id,
            groupName:
                'Групповая тренировка', // Позже можно будет доставать реальное имя группы
          ),
        ),
      );
      return; // Прерываем выполнение, чтобы не открылась шторка редактирования
    }

    // В ОСТАЛЬНЫХ СЛУЧАЯХ (создание нового или аренда) -> ОТКРЫВАЕМ ШТОРКУ СОЗДАНИЯ/РЕДАКТИРОВАНИЯ
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => CreateScheduleEventSheet(
        courtId: courtId,
        startHour: hour,
        date: state.scheduleDate,
        groups: state.groups,
        coaches: state.coaches,
        existingEvent: existingEvent,
        onSave:
            ({
              required eventType,
              required startTime,
              required endTime,
              required color,
              clientName,
              clientPhone,
              coachId,
              groupId,
            }) {
              String formatTime(TimeOfDay t) =>
                  "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

              if (existingEvent == null) {
                context.read<ScheduleBloc>().add(
                  CreateScheduleEventRequested({
                    'type': eventType,
                    'date': state.scheduleDate.toIso8601String(),
                    'startTime': formatTime(startTime),
                    'endTime': formatTime(endTime),
                    'colorHex': color,
                    'courtId': courtId,
                    'groupId': groupId,
                    'clientName': clientName,
                    'clientPhone': clientPhone,
                    'coachId': coachId,
                  }),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Редактирование пока недоступно'),
                  ),
                );
              }
              Navigator.pop(ctx);
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана, чтобы понять, десктоп это или нет
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    // Убрали BlocProvider, так как мы получаем ScheduleBloc из DashboardScreen
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleError) {
          return Center(
            child: Text(
              'Ошибка: ${state.message}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }
        if (state is ScheduleLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ScheduleLoaded) {
          final isPastDate =
              DateTime(
                state.scheduleDate.year,
                state.scheduleDate.month,
                state.scheduleDate.day,
              ).isBefore(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              );

          return Column(
            children: [
              // Показываем горизонтальный календарь ТОЛЬКО на мобилках/планшетах
              if (!isDesktop)
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: WeeklyCalendar(
                    selectedDate: state.scheduleDate,
                    onDateSelected: (date) => context.read<ScheduleBloc>().add(
                      LoadScheduleData(date),
                    ),
                    onWeekChanged: (offset) =>
                        _changeWeek(context, state.scheduleDate, offset),
                  ),
                ),
              if (!isDesktop) const Divider(height: 1),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Расписание',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!isPastDate)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Корт'),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<ScheduleBloc>(),
                            child: CreateCourtDialog(
                              onSave: (name) => context
                                  .read<ScheduleBloc>()
                                  .add(CreateCourtRequested(name)),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: ScheduleGridView(
                  state: state,
                  isPastDate: isPastDate,
                  onEditCourt: (courtId, courtName) => showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: context.read<ScheduleBloc>(),
                      child: CreateCourtDialog(
                        initialName: courtName,
                        onSave: (newName) => context.read<ScheduleBloc>().add(
                          UpdateCourtRequested(courtId, newName),
                        ),
                      ),
                    ),
                  ),
                  // Добавили minute в вызов (хоть мы его пока и игнорируем при передаче в _openEventSheet)
                  onTimeSlotTapped: (courtId, hour, minute) => isPastDate
                      ? ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Нельзя изменять в прошлом'),
                          ),
                        )
                      : _openEventSheet(context, state, courtId, hour),
                  onEventTapped: (event) => _openEventSheet(
                    context,
                    state,
                    event.courtId,
                    event.startTime.hour,
                    existingEvent: event,
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
