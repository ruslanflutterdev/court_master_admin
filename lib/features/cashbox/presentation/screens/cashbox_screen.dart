import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../bloc/cashbox_bloc.dart';
import '../bloc/cashbox_event.dart';
import '../bloc/cashbox_state.dart';
import '../widgets/cashbox_status_card.dart';
import '../widgets/cashbox_shift_report_dialog.dart';

class CashboxScreen extends StatelessWidget {
  const CashboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cashboxBloc = context.read<CashboxBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text('Сверка кассы')),
      body: BlocConsumer<CashboxBloc, CashboxState>(
        listener: (context, state) {
          if (state is CashboxError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is CashboxShiftClosed) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => CashboxShiftReportDialog(
                result: state.result,
                bloc: cashboxBloc,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CashboxLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CashboxLoaded) {
            return CashboxStatusCard(data: state.status, bloc: cashboxBloc);
          }

          return Center(
            child: PrimaryButton(
              text: 'Проверить статус',
              onPressed: () => cashboxBloc.add(LoadCashboxStatus()),
            ),
          );
        },
      ),
    );
  }
}
