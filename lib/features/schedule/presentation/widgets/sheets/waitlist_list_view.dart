import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/waitlist_model.dart';
import '../../bloc/waitlist_bloc.dart';
import '../../bloc/waitlist_event.dart';
import 'waitlist_item_tile.dart';

class WaitlistListView extends StatelessWidget {
  final List<WaitlistModel> items;
  final bool isGroup;
  final DateTime date;

  const WaitlistListView({
    super.key,
    required this.items,
    required this.isGroup,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('Пока никого нет'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return WaitlistItemTile(
          item: item,
          isGroup: isGroup,
          onDelete: () => context.read<WaitlistBloc>().add(
            RemoveFromWaitlist(item.id, date),
          ),
        );
      },
    );
  }
}
