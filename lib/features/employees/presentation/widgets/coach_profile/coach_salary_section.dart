import 'package:flutter/material.dart';
import 'coach_salary_card.dart';

class CoachSalarySection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isEditing;
  final TextEditingController iStateCtrl;
  final TextEditingController iClubCtrl;
  final TextEditingController gStateCtrl;
  final TextEditingController gClubCtrl;
  final TextEditingController sStateCtrl;
  final TextEditingController sClubCtrl;
  final double iStateVal;
  final double iClubVal;
  final double gStateVal;
  final double gClubVal;
  final double sStateVal;
  final double sClubVal;

  const CoachSalarySection({
    super.key,
    required this.stats,
    required this.isEditing,
    required this.iStateCtrl,
    required this.iClubCtrl,
    required this.gStateCtrl,
    required this.gClubCtrl,
    required this.sStateCtrl,
    required this.sClubCtrl,
    required this.iStateVal,
    required this.iClubVal,
    required this.gStateVal,
    required this.gClubVal,
    required this.sStateVal,
    required this.sClubVal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          CoachSalaryCard(
            title: 'Индивидуальные',
            stateCtrl: iStateCtrl,
            clubCtrl: iClubCtrl,
            stateVal: iStateVal,
            clubVal: iClubVal,
            color: Colors.green,
            earnedSalary: stats['indivSalary'] ?? 0,
            isEditing: isEditing,
          ),
          CoachSalaryCard(
            title: 'Абонементы (Группы)',
            stateCtrl: gStateCtrl,
            clubCtrl: gClubCtrl,
            stateVal: gStateVal,
            clubVal: gClubVal,
            color: Colors.blue,
            earnedSalary: stats['groupSalary'] ?? 0,
            isEditing: isEditing,
          ),
          CoachSalaryCard(
            title: 'Разовые тренировки',
            stateCtrl: sStateCtrl,
            clubCtrl: sClubCtrl,
            stateVal: sStateVal,
            clubVal: sClubVal,
            color: Colors.orange,
            earnedSalary: stats['singleSalary'] ?? 0,
            isEditing: isEditing,
          ),
        ];

        if (constraints.maxWidth > 800) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cards
                .map(
                  (c) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: c,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: cards
              .map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: c,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
