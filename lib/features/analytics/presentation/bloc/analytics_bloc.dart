import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/analytics_repository.dart';
import 'analytics_event.dart';
import 'analytics_state.dart';

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
