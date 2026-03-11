import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/schedule_bloc.dart';
import '../../bloc/schedule_event.dart';
import '../dialogs/create_court_dialog.dart';

class ScheduleHeader extends StatelessWidget {
  final bool isPastDate;

  const ScheduleHeader({super.key, required this.isPastDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Расписание',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (!isPastDate)
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Корт'),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: context.read<ScheduleBloc>(),
                  child: CreateCourtDialog(
                    onSave: (name) => context.read<ScheduleBloc>().add(
                      CreateCourtRequested(name),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
