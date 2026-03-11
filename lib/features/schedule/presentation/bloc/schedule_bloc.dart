import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../../groups/data/repositories/groups_repository.dart';
import '../../../employees/data/repositories/employees_repository.dart';
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
      try {
        final courts = await scheduleRepo.getCourts();
        final allEvents = await scheduleRepo.getEvents();
        final groups = await groupsRepo.getGroups();
        final coaches = await employeesRepo.getCoaches();

        final dailyEvents = allEvents
            .where(
              (e) =>
                  e.date.year == _currentDate.year &&
                  e.date.month == _currentDate.month &&
                  e.date.day == _currentDate.day,
            )
            .toList();

        emit(
          ScheduleLoaded(
            scheduleDate: _currentDate,
            courts: courts,
            scheduleEvents: dailyEvents,
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
      await scheduleRepo.createEvent(event.eventData);
      add(LoadScheduleData(_currentDate));
    });
  }
}
