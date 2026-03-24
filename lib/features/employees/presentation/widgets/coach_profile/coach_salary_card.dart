import 'package:flutter/material.dart';
import 'coach_salary_row_item.dart';

class CoachSalaryCard extends StatelessWidget {
  final String title;
  final TextEditingController stateCtrl;
  final TextEditingController clubCtrl;
  final double stateVal;
  final double clubVal;
  final Color color;
  final num earnedSalary;
  final bool isEditing;

  const CoachSalaryCard({
    super.key,
    required this.title,
    required this.stateCtrl,
    required this.clubCtrl,
    required this.stateVal,
    required this.clubVal,
    required this.color,
    required this.earnedSalary,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withAlpha(50), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color.withAlpha(200),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                CoachSalaryRowItem(
                  label: 'Налог гос-ва:',
                  controller: stateCtrl,
                  value: stateVal,
                  isEditing: isEditing,
                ),
                CoachSalaryRowItem(
                  label: 'Налог клуба:',
                  controller: clubCtrl,
                  value: clubVal,
                  isEditing: isEditing,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: color.withAlpha(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Заработано:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.withAlpha(200),
                  ),
                ),
                Text(
                  '$earnedSalary ₸',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
