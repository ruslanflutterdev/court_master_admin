import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/schedule_bloc.dart';
import '../bloc/schedule_event.dart';
import '../bloc/schedule_state.dart';
import '../bloc/waitlist_bloc.dart';
import '../bloc/waitlist_event.dart';
import '../widgets/views/schedule_body.dart';
import '../widgets/views/schedule_header.dart';
import '../widgets/views/schedule_week_view.dart';
import '../utils/schedule_actions.dart';
import '../widgets/dialogs/create_court_dialog.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/bloc/clients_event.dart';
import '../../../clients/presentation/widgets/sheets/quick_sale_sheet.dart';

class AdminScheduleTab extends StatefulWidget {
  const AdminScheduleTab({super.key});

  @override
  State<AdminScheduleTab> createState() => _AdminScheduleTabState();
}

class _AdminScheduleTabState extends State<AdminScheduleTab> {
  String currentView = 'day';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<WaitlistBloc>()..add(LoadWaitlist(DateTime.now())),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ScheduleError) {
                return Center(child: Text('Ошибка: ${state.message}'));
              }

              if (state is ScheduleLoaded) {
                final isPastDate = state.scheduleDate.isBefore(
                  DateTime.now().subtract(const Duration(days: 1)),
                );

                return Column(
                  children: [
                    ScheduleHeader(
                      date: state.scheduleDate,
                      isPastDate: isPastDate,
                      currentView: currentView,
                      onViewChanged: (newView) {
                        setState(() {
                          currentView = newView;
                        });
                      },
                      onQuickSale: () async {
                        final clientsBloc = context.read<ClientsBloc>();
                        await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (_) => BlocProvider.value(
                            value: clientsBloc,
                            child: const QuickSaleSheet(),
                          ),
                        );
                        clientsBloc.add(LoadClientsEvent());
                      },
                      onCreateCourt: () {
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: context.read<ScheduleBloc>(),
                            child: CreateCourtDialog(
                              onSave: (name) => context
                                  .read<ScheduleBloc>()
                                  .add(CreateCourtRequested(name)),
                            ),
                          ),
                        );
                      },
                    ),

                    // Переключатель дней (без клика по календарю)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => ScheduleActions.changeWeek(
                              context,
                              state.scheduleDate,
                              -1,
                            ),
                          ),
                          Text(
                            '${state.scheduleDate.day.toString().padLeft(2, '0')}.${state.scheduleDate.month.toString().padLeft(2, '0')}.${state.scheduleDate.year}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => ScheduleActions.changeWeek(
                              context,
                              state.scheduleDate,
                              1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: currentView == 'day'
                          ? ScheduleBody(
                              state: state,
                              isPastDate: isPastDate,
                              onEditCourt: (courtId, courtName) =>
                                  ScheduleActions.openEditCourtDialog(
                                    context,
                                    courtId,
                                    courtName,
                                  ),
                              onTimeSlotTapped: (courtId, hour, minute) =>
                                  ScheduleActions.openEventSheet(
                                    context,
                                    state,
                                    courtId,
                                    hour,
                                  ),
                              onEventTapped: (event) =>
                                  ScheduleActions.openEventSheet(
                                    context,
                                    state,
                                    event.courtId,
                                    event.startTime.hour,
                                    existingEvent: event,
                                  ),
                            )
                          : ScheduleWeekView(
                              state: state,
                              onTimeSlotTapped: (courtId, hour, minute, date) =>
                                  ScheduleActions.openEventSheet(
                                    context,
                                    state,
                                    courtId,
                                    hour,
                                  ),
                              onEventTapped: (event) =>
                                  ScheduleActions.openEventSheet(
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
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
