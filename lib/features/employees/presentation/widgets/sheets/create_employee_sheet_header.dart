import 'package:flutter/material.dart';

class CreateEmployeeSheetHeader extends StatelessWidget {
  const CreateEmployeeSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Icon(Icons.person_add, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'Новый сотрудник',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Divider(height: 32),
      ],
    );
  }
}
