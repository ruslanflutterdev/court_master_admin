import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/court_model.dart';
import '../../data/models/schedule_event_model.dart';
import '../../data/repositories/schedule_repository.dart';
import '../../../groups/data/models/group_model.dart';
import '../../../groups/data/repositories/groups_repository.dart';
import '../../../employees/data/models/coach_model.dart';
import '../../../employees/data/repositories/employees_repository.dart';

abstract class ScheduleEvent {}

class LoadScheduleData extends ScheduleEvent {
  final DateTime date;
  LoadScheduleData(this.date);
}

class CreateCourtRequested extends ScheduleEvent {
  final String name;
  CreateCourtRequested(this.name);
}

class UpdateCourtRequested extends ScheduleEvent {
  final String courtId;
  final String name;
  UpdateCourtRequested(this.courtId, this.name);
}

class CreateScheduleEventRequested extends ScheduleEvent {
  final Map<String, dynamic> eventData;
  CreateScheduleEventRequested(this.eventData);
}

abstract class ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleError extends ScheduleState {
  final String message;
  ScheduleError(this.message);
}

class ScheduleLoaded extends ScheduleState {
  final DateTime scheduleDate;
  final List<CourtModel> courts;
  final List<ScheduleEventModel> scheduleEvents;
  final List<GroupModel> groups;
  final List<CoachModel> coaches;

  ScheduleLoaded({
    required this.scheduleDate,
    required this.courts,
    required this.scheduleEvents,
    required this.groups,
    required this.coaches,
  });
}

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
