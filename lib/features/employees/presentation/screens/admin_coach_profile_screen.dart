import 'package:flutter/material.dart';
import '../../data/models/coach_model.dart';
import '../widgets/coach_profile/coach_profile_header.dart';
import '../widgets/coach_profile/coach_salary_section.dart';
import '../widgets/coach_profile/coach_save_button.dart';
import 'mixins/coach_profile_logic_mixin.dart';

class AdminCoachProfileScreen extends StatefulWidget {
  final CoachModel coach;
  const AdminCoachProfileScreen({super.key, required this.coach});

  @override
  State<AdminCoachProfileScreen> createState() =>
      _AdminCoachProfileScreenState();
}

class _AdminCoachProfileScreenState extends State<AdminCoachProfileScreen>
    with CoachProfileLogicMixin {
  @override
  void initState() {
    super.initState();
    initCoachLogic(widget.coach);
  }

  @override
  void dispose() {
    disposeCoachLogic();
    super.dispose();
  }

  void _onSave() {
    saveSalarySettings(widget.coach.id, () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Сохранено!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Договор и Начисления',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(
            isEditing ? Icons.close : Icons.edit,
            color: isEditing ? Colors.red : Colors.blue,
          ),
          onPressed: toggleEdit,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль тренера')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchStats(widget.coach.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final stats = snapshot.data ?? {};

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoachProfileHeader(coach: widget.coach),
                const Divider(height: 40),
                _buildSectionHeader(),
                const SizedBox(height: 8),
                CoachSalarySection(
                  stats: stats,
                  isEditing: isEditing,
                  iStateCtrl: iStateTaxCtrl,
                  iClubCtrl: iClubTaxCtrl,
                  gStateCtrl: gStateTaxCtrl,
                  gClubCtrl: gClubTaxCtrl,
                  sStateCtrl: sStateTaxCtrl,
                  sClubCtrl: sClubTaxCtrl,
                  iStateVal: iStateTax,
                  iClubVal: iClubTax,
                  gStateVal: gStateTax,
                  gClubVal: gClubTax,
                  sStateVal: sStateTax,
                  sClubVal: sClubTax,
                ),
                if (isEditing) ...[
                  const SizedBox(height: 24),
                  CoachSaveButton(isLoading: isLoading, onPressed: _onSave),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
