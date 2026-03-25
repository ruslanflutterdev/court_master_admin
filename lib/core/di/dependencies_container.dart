import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/employees/data/repositories/employees_repository.dart';
import '../../features/employees/presentation/bloc/employees_bloc.dart';
import '../../features/groups/data/repositories/groups_repository.dart';
import '../../features/groups/data/repositories/students_repository.dart';
import '../../features/groups/presentation/bloc/group_details_bloc.dart';
import '../../features/groups/presentation/bloc/groups_bloc.dart';
import '../../features/schedule/data/repositories/schedule_repository.dart';
import '../../features/schedule/presentation/bloc/event_attendance_bloc.dart';
import '../../features/schedule/presentation/bloc/schedule_bloc.dart';
import '../../features/schedule/presentation/bloc/waitlist_bloc.dart';
import '../../features/clients/data/repositories/clients_repository.dart';
import '../../features/clients/presentation/bloc/client_details_bloc.dart';
import '../../features/clients/presentation/bloc/clients_bloc.dart';
import '../../features/analytics/data/repositories/analytics_repository.dart';
import '../../features/analytics/presentation/bloc/analytics_bloc.dart';
import '../../features/cashbox/data/repositories/cashbox_repository.dart';
import '../../features/cashbox/presentation/bloc/cashbox_bloc.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<ApiClient>(() => ApiClient(sl()));

  _initAuth();
  _initEmployees();
  _initGroups();
  _initSchedule();
  _initClients();
  _initAnalytics();
  _initCashbox();
}

void _initCashbox() {
  sl.registerLazySingleton<CashboxRepository>(() => CashboxRepository(sl()));
  sl.registerFactory(() => CashboxBloc(repository: sl()));
}

void _initAuth() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerFactory(() => AuthBloc(repository: sl()));
}

void _initEmployees() {
  sl.registerLazySingleton<EmployeesRepository>(
    () => EmployeesRepository(apiClient: sl()),
  );
  sl.registerFactory(() => EmployeesBloc(repository: sl()));
}

void _initGroups() {
  sl.registerLazySingleton<GroupsRepository>(() => GroupsRepository(sl()));
  sl.registerLazySingleton<StudentsRepository>(() => StudentsRepository(sl()));
  sl.registerFactory(() => GroupsBloc(repository: sl()));
  sl.registerFactory(() => GroupDetailsBloc(repository: sl()));
}

void _initSchedule() {
  sl.registerLazySingleton<ScheduleRepository>(() => ScheduleRepository(sl()));
  sl.registerFactory(
    () =>
        ScheduleBloc(scheduleRepo: sl(), groupsRepo: sl(), employeesRepo: sl()),
  );
  sl.registerFactory(() => EventAttendanceBloc(repository: sl()));
  sl.registerFactory(() => WaitlistBloc(repository: sl()));
}

void _initClients() {
  sl.registerLazySingleton<ClientsRepository>(() => ClientsRepository(sl()));
  sl.registerFactory(() => ClientsBloc(repository: sl()));
  sl.registerFactory(() => ClientDetailsBloc(repository: sl()));
}

void _initAnalytics() {
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepository(apiClient: sl()),
  );
  sl.registerFactory(() => AnalyticsBloc(repository: sl()));
}
