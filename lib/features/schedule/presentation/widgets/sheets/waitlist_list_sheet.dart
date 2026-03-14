import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/waitlist_bloc.dart';
import '../../bloc/waitlist_event.dart';
import '../../bloc/waitlist_state.dart';
import '../../utils/waitlist_actions.dart';

class WaitlistListSheet extends StatelessWidget {
  final DateTime date;
  const WaitlistListSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Лист ожидания',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () =>
                    WaitlistActions.openAddWaitlistSheet(context, date),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: BlocBuilder<WaitlistBloc, WaitlistState>(
              builder: (context, state) {
                if (state is WaitlistLoading)
                  return const Center(child: CircularProgressIndicator());
                if (state is WaitlistError)
                  return Center(child: Text(state.message));
                if (state is WaitlistLoaded) {
                  if (state.waitlist.isEmpty)
                    return const Center(child: Text('Пока никого нет'));
                  return ListView.builder(
                    itemCount: state.waitlist.length,
                    itemBuilder: (ctx, i) {
                      final item = state.waitlist[i];
                      return ListTile(
                        title: Text(item.clientName ?? 'Гость'),
                        subtitle: Text(
                          '${item.startTime} - ${item.endTime} | ${item.clientPhone ?? ''}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => context.read<WaitlistBloc>().add(
                            RemoveFromWaitlist(item.id, date),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
