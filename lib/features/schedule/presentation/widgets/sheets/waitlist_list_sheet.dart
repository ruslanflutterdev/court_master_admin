import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/waitlist_header.dart';
import 'package:court_master_admin/features/schedule/presentation/widgets/sheets/waitlist_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/waitlist_bloc.dart';
import '../../bloc/waitlist_state.dart';

class WaitlistListSheet extends StatelessWidget {
  final DateTime date;

  const WaitlistListSheet({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 0),
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            WaitlistHeader(date: date),
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Аренда'),
                Tab(text: 'В группу'),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<WaitlistBloc, WaitlistState>(
                builder: (context, state) {
                  if (state is WaitlistLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is WaitlistError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is WaitlistLoaded) {
                    return TabBarView(
                      children: [
                        WaitlistListView(
                          items: state.rentalWaitlist,
                          isGroup: false,
                          date: date,
                        ),
                        WaitlistListView(
                          items: state.groupWaitlist,
                          isGroup: true,
                          date: date,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
