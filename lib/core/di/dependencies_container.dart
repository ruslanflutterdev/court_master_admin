import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/employees/data/repositories/employees_repository.dart';
import '../../features/employees/presentation/bloc/employees_bloc.dart';
import '../../features/groups/data/repositories/groups_repository.dart';
import '../../features/groups/presentation/bloc/groups_bloc.dart';
import '../api/api_client.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

final sl = GetIt.instance;

Future<void> initInjection() async {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(sl()),
  );
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerLazySingleton<EmployeesRepository>(() => EmployeesRepository(sl()));
  sl.registerFactory(() => EmployeesBloc(repository: sl()));
  sl.registerLazySingleton<GroupsRepository>(() => GroupsRepository(sl()));
  sl.registerFactory(() => GroupsBloc(repository: sl()));
}