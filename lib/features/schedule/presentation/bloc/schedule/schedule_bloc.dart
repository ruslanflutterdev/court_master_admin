import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../employees/data/models/coach_model.dart';
import '../../../../groups/data/models/group_model.dart';
import '../../../data/models/court_model.dart';
import '../../../data/repositories/schedule_repository.dart';
import '../../../../groups/data/repositories/groups_repository.dart';
import '../../../../employees/data/repositories/employees_repository.dart';
import '../../utils/schedule_date_helper.dart';
import 'schedule_event.dart';
import 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepo;
  final GroupsRepository groupsRepo;
  final EmployeesRepository employeesRepo;

  DateTime _currentDate = DateTime.now();

  ScheduleBloc({
    required this.scheduleRepo,
    required this.groupsRepo,
    required this.employeesRepo,
  }) : super(ScheduleLoading()) {
    on<LoadScheduleData>((event, emit) async {
      emit(ScheduleLoading());
      _currentDate = event.date;
      ScheduleViewType currentViewType = event.viewType ?? ScheduleViewType.day;
      if (event.viewType == null && state is ScheduleLoaded) {
        currentViewType = (state as ScheduleLoaded).viewType;
      }

      try {
        final dateRange = ScheduleDateHelper.getDateRange(
          _currentDate,
          currentViewType,
        );

        final results = await Future.wait([
          scheduleRepo.getCourts(),
          groupsRepo.getGroups(),
          employeesRepo.getCoaches(),
        ]);

        final courts = results[0] as List<CourtModel>;
        final groups = (results[1] as List).cast<GroupModel>();
        final coaches = (results[2] as List).cast<CoachModel>();
        final periodEvents = await scheduleRepo.getEvents(
          startDate: dateRange['start']!.toIso8601String(),
          endDate: dateRange['end']!.toIso8601String(),
        );

        emit(
          ScheduleLoaded(
            scheduleDate: _currentDate,
            viewType: currentViewType,
            courts: courts,
            scheduleEvents: periodEvents,
            groups: groups,
            coaches: coaches,
          ),
        );
      } catch (e) {
        emit(ScheduleError(e.toString()));
      }
    });

    on<CreateCourtRequested>((event, emit) async {
      await scheduleRepo.createCourt(event.name);
      add(LoadScheduleData(_currentDate));
    });

    on<UpdateCourtRequested>((event, emit) async {
      await scheduleRepo.updateCourt(event.courtId, event.name);
      add(LoadScheduleData(_currentDate));
    });

    on<CreateScheduleEventRequested>((event, emit) async {
      try {
        await scheduleRepo.createEvent(event.eventData);
        add(LoadScheduleData(_currentDate));
      } catch (e) {
        emit(ScheduleError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<ChangeScheduleViewTypeRequested>((event, emit) {
      add(LoadScheduleData(_currentDate, viewType: event.viewType));
    });

    on<UpdateScheduleEvent>((event, emit) async {
      try {
        await scheduleRepo.updateEvent(event.eventId, event.eventData);
        add(LoadScheduleData(event.currentDate));
      } catch (e) {
        emit(ScheduleError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<CancelScheduleEventRequested>((event, emit) async {
      try {
        await scheduleRepo.cancelEvent(event.eventId);
        add(LoadScheduleData(event.currentDate));
      } catch (e) {
        emit(ScheduleError(e.toString().replaceAll('Exception: ', '')));
      }
    });

    on<CancelScheduleEventSeriesRequested>((event, emit) async {
      try {
        await scheduleRepo.cancelEventSeries(event.seriesId);
        add(LoadScheduleData(event.currentDate));
      } catch (e) {
        emit(ScheduleError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
