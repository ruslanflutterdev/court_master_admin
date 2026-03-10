import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/dependencies_container.dart';
import 'core/router/app_router.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjection();
  runApp(const CourtMasterAdminApp());
}

class CourtMasterAdminApp extends StatelessWidget {
  const CourtMasterAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AuthBloc>(),
      child: MaterialApp.router(
        title: 'CourtMaster Admin',
        theme: ThemeData(primarySwatch: Colors.green),
        routerConfig: appRouter,
      ),
    );
  }
}
