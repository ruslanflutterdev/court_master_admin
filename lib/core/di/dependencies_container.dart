import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/clients/data/repositories/clients_repository.dart';
import '../../features/clients/presentation/bloc/client_details_bloc.dart';
import '../../features/clients/presentation/bloc/clients_bloc.dart';
import '../../features/employees/data/repositories/employees_repository.dart';
import '../../features/employees/presentation/bloc/employees_bloc.dart';
import '../../features/groups/data/repositories/groups_repository.dart';
import '../../features/groups/data/repositories/students_repository.dart';
import '../../features/groups/presentation/bloc/group_details_bloc.dart';
import '../../features/groups/presentation/bloc/groups_bloc.dart';
import '../../features/schedule/data/repositories/schedule_repository.dart';
import '../../features/schedule/presentation/bloc/schedule_bloc.dart';
import '../api/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerLazySingleton<EmployeesRepository>(
    () => EmployeesRepository(sl()),
  );
  sl.registerFactory(() => EmployeesBloc(repository: sl()));
  sl.registerLazySingleton<GroupsRepository>(() => GroupsRepository(sl()));
  sl.registerFactory(() => GroupsBloc(repository: sl()));
  sl.registerLazySingleton<StudentsRepository>(() => StudentsRepository(sl()));
  sl.registerFactory(() => GroupDetailsBloc(repository: sl()));
  sl.registerLazySingleton<ScheduleRepository>(() => ScheduleRepository(sl()));
  sl.registerFactory(
    () =>
        ScheduleBloc(scheduleRepo: sl(), groupsRepo: sl(), employeesRepo: sl()),
  );
  sl.registerLazySingleton<ClientsRepository>(() => ClientsRepository(sl()));
  sl.registerFactory(() => ClientsBloc(repository: sl()));
  sl.registerFactory(() => ClientDetailsBloc(repository: sl()));
}
