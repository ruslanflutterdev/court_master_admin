import 'package:flutter/material.dart';

class TimeColumn extends StatelessWidget {
  const TimeColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          const SizedBox(height: 48),
          ...List.generate(36, (index) {
            final hour = 6 + (index ~/ 2);
            final minute = (index % 2) == 0 ? '00' : '30';
            return Container(
              height: 40,
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Text(
                '$hour:$minute',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            );
          }),
        ],
      ),
    );
  }
}
