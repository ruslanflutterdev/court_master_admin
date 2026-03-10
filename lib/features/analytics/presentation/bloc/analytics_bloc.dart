import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/analytics_model.dart';
import '../../data/repositories/analytics_repository.dart';

// --- События ---
abstract class AnalyticsEvent {}

class LoadAnalyticsEvent extends AnalyticsEvent {}

// --- Состояния ---
abstract class AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsModel data;
  AnalyticsLoaded(this.data);
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}

// --- BLoC ---
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository repository;

  AnalyticsBloc({required this.repository}) : super(AnalyticsLoading()) {
    on<LoadAnalyticsEvent>((event, emit) async {
      emit(AnalyticsLoading());
      try {
        final data = await repository.getDashboardData();
        emit(AnalyticsLoaded(data));
      } catch (e) {
        emit(AnalyticsError(e.toString().replaceAll('Exception: ', '')));
      }
    });
  }
}
