import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependencies_container.dart';
import '../bloc/waitlist/waitlist_bloc.dart';
import '../bloc/waitlist/waitlist_event.dart';
import '../widgets/sheets/add_waitlist_sheet.dart';
import '../widgets/sheets/waitlist_list_sheet.dart';

class WaitlistActions {
  static void openWaitlistSheet(BuildContext context, DateTime date) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<WaitlistBloc>()..add(LoadWaitlist(date)),
        child: WaitlistListSheet(date: date),
      ),
    );
  }

  static void openAddWaitlistSheet(BuildContext context, DateTime date) {
    final bloc = context.read<WaitlistBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: AddWaitlistSheet(date: date),
      ),
    );
  }
}
