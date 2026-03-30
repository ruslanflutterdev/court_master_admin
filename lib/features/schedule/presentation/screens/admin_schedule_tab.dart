import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../../../clients/presentation/widgets/sections/quick_sale_sheet.dart';
import '../../../clients/presentation/bloc/clients_bloc.dart';
import '../../../clients/presentation/bloc/clients_event.dart';
import '../../data/models/schedule_event_model.dart';
import '../bloc/cashbox/cashbox_bloc.dart';
import '../bloc/cashbox/cashbox_state.dart';
import '../bloc/schedule/schedule_bloc.dart';
import '../bloc/schedule/schedule_event.dart';
import '../bloc/schedule/schedule_state.dart';
import '../bloc/waitlist/waitlist_bloc.dart';
import '../bloc/waitlist/waitlist_event.dart';
import '../widgets/dialogs/cashbox_shift_report_dialog.dart';
import '../widgets/views/schedule_body.dart';
import '../widgets/views/schedule_header.dart';
import '../widgets/views/schedule_week_view.dart';
import '../widgets/views/schedule_date_selector.dart';
import '../utils/schedule_actions.dart';
import '../widgets/dialogs/create_court_dialog.dart';

class AdminScheduleTab extends StatefulWidget {
  const AdminScheduleTab({super.key});

  @override
  State<AdminScheduleTab> createState() => _AdminScheduleTabState();
}

class _AdminScheduleTabState extends State<AdminScheduleTab> {
  String _currentView = 'day';

  void _onViewChanged(String newView) => setState(() => _currentView = newView);

  void _changeDay(DateTime current, int offset) {
    ScheduleActions.changeWeek(context, current, offset);
  }

  Future<void> _onQuickSale() async {
    final clientsBloc = context.read<ClientsBloc>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          BlocProvider.value(value: clientsBloc, child: const QuickSaleSheet()),
    );
    clientsBloc.add(LoadClientsEvent());
  }

  void _onCreateCourt() {
    final bloc = context.read<ScheduleBloc>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: CreateCourtDialog(
          onSave: (name) => bloc.add(CreateCourtRequested(name)),
        ),
      ),
    );
  }

  void _onTimeSlotTapped(
    ScheduleLoaded state,
    String id,
    int h,
    int m, [
    DateTime? d,
  ]) {
    ScheduleActions.openEventSheet(context, state, id, h);
  }

  void _onEventTapped(ScheduleLoaded state, ScheduleEventModel e) {
    ScheduleActions.openEventSheet(
      context,
      state,
      e.courtId,
      e.startTime.hour,
      existingEvent: e,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WaitlistBloc>()..add(LoadWaitlist(DateTime.now())),
      child: BlocListener<CashboxBloc, CashboxState>(
        listener: (context, cashboxState) {
          if (cashboxState is CashboxError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(cashboxState.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (cashboxState is CashboxShiftClosed) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => CashboxShiftReportDialog(
                result: cashboxState.result,
                bloc: context.read<CashboxBloc>(),
              ),
            );
          }
        },
        child: Builder(
          builder: (context) => BlocBuilder<ScheduleBloc, ScheduleState>(
            builder: (context, state) {
              if (state is ScheduleLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ScheduleError) {
                return Center(child: Text(state.message));
              }
              if (state is! ScheduleLoaded) return const SizedBox();

              final isPast = state.scheduleDate.isBefore(
                DateTime.now().subtract(const Duration(days: 1)),
              );

              return Column(
                children: [
                  ScheduleHeader(
                    date: state.scheduleDate,
                    isPastDate: isPast,
                    currentView: _currentView,
                    onViewChanged: _onViewChanged,
                    onQuickSale: _onQuickSale,
                    onCreateCourt: _onCreateCourt,
                  ),
                  ScheduleDateSelector(
                    date: state.scheduleDate,
                    onPrevious: () => _changeDay(state.scheduleDate, -1),
                    onNext: () => _changeDay(state.scheduleDate, 1),
                  ),
                  Expanded(
                    child: _currentView == 'day'
                        ? ScheduleBody(
                            state: state,
                            isPastDate: isPast,
                            onEditCourt: (id, name) =>
                                ScheduleActions.openEditCourtDialog(
                                  context,
                                  id,
                                  name,
                                ),
                            onTimeSlotTapped: (id, h, m) =>
                                _onTimeSlotTapped(state, id, h, m),
                            onEventTapped: (e) => _onEventTapped(state, e),
                          )
                        : ScheduleWeekView(
                            state: state,
                            onTimeSlotTapped: (id, h, m, d) =>
                                _onTimeSlotTapped(state, id, h, m, d),
                            onEventTapped: (e) => _onEventTapped(state, e),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
