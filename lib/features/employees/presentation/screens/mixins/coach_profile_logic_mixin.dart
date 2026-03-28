import 'package:flutter/material.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/di/dependencies_container.dart';
import '../../../data/models/coach_model.dart';

mixin CoachProfileLogicMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;
  bool isEditing = false;

  late double iStateTax, iClubTax, gStateTax, gClubTax, sStateTax, sClubTax;
  late final TextEditingController iStateTaxCtrl,
      iClubTaxCtrl,
      gStateTaxCtrl,
      gClubTaxCtrl,
      sStateTaxCtrl,
      sClubTaxCtrl;

  void initCoachLogic(CoachModel coach) {
    iStateTax = coach.indivStateTaxRate;
    iClubTax = coach.indivClubTaxRate;
    gStateTax = coach.groupStateTaxRate;
    gClubTax = coach.groupClubTaxRate;
    sStateTax = coach.singleStateTaxRate;
    sClubTax = coach.singleClubTaxRate;

    iStateTaxCtrl = TextEditingController(text: iStateTax.toInt().toString());
    iClubTaxCtrl = TextEditingController(text: iClubTax.toInt().toString());
    gStateTaxCtrl = TextEditingController(text: gStateTax.toInt().toString());
    gClubTaxCtrl = TextEditingController(text: gClubTax.toInt().toString());
    sStateTaxCtrl = TextEditingController(text: sStateTax.toInt().toString());
    sClubTaxCtrl = TextEditingController(text: sClubTax.toInt().toString());
  }

  void disposeCoachLogic() {
    iStateTaxCtrl.dispose();
    iClubTaxCtrl.dispose();
    gStateTaxCtrl.dispose();
    gClubTaxCtrl.dispose();
    sStateTaxCtrl.dispose();
    sClubTaxCtrl.dispose();
  }

  Future<Map<String, dynamic>> fetchStats(String coachId) async {
    final response = await sl<ApiClient>().dio.get('/employees/$coachId/stats');
    return response.data;
  }

  Future<void> saveSalarySettings(
    String coachId,
    VoidCallback onSuccess,
  ) async {
    setState(() => isLoading = true);
    try {
      final iState = double.tryParse(iStateTaxCtrl.text) ?? 0;
      final iClub = double.tryParse(iClubTaxCtrl.text) ?? 0;
      final gState = double.tryParse(gStateTaxCtrl.text) ?? 0;
      final gClub = double.tryParse(gClubTaxCtrl.text) ?? 0;
      final sState = double.tryParse(sStateTaxCtrl.text) ?? 0;
      final sClub = double.tryParse(sClubTaxCtrl.text) ?? 0;

      await sl<ApiClient>().dio.put(
        '/employees/$coachId',
        data: {
          'indivStateTaxRate': iState,
          'indivClubTaxRate': iClub,
          'groupStateTaxRate': gState,
          'groupClubTaxRate': gClub,
          'singleStateTaxRate': sState,
          'singleClubTaxRate': sClub,
        },
      );

      iStateTax = iState;
      iClubTax = iClub;
      gStateTax = gState;
      gClubTax = gClub;
      sStateTax = sState;
      sClubTax = sClub;

      onSuccess();
      setState(() => isEditing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleEdit() {
    setState(() {
      if (isEditing) {
        iStateTaxCtrl.text = iStateTax.toInt().toString();
        iClubTaxCtrl.text = iClubTax.toInt().toString();
        gStateTaxCtrl.text = gStateTax.toInt().toString();
        gClubTaxCtrl.text = gClubTax.toInt().toString();
        sStateTaxCtrl.text = sStateTax.toInt().toString();
        sClubTaxCtrl.text = sClubTax.toInt().toString();
      }
      isEditing = !isEditing;
    });
  }
}
