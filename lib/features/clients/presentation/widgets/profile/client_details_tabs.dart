import 'package:flutter/material.dart';
import '../../../data/models/client_model.dart';
import 'client_attendance_list.dart';
import 'client_payments_list.dart';

class ClientDetailsTabs extends StatelessWidget {
  final ClientModel client;

  const ClientDetailsTabs({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Посещаемость', icon: Icon(Icons.calendar_month)),
              Tab(text: 'История оплат', icon: Icon(Icons.history)),
            ],
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          SizedBox(
            height: 400,
            child: TabBarView(
              children: [
                ClientAttendanceList(attendances: client.attendances ?? []),
                ClientPaymentsList(
                  clientId: client.id,
                  transactions: client.transactions ?? [],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
