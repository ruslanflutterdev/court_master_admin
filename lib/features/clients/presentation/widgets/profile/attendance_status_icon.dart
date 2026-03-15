import 'package:flutter/material.dart';

class AttendanceStatusIcon extends StatelessWidget {
  final int status;

  const AttendanceStatusIcon({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 1:
        return const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.check, color: Colors.white),
        );
      case 2:
        return const CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(Icons.close, color: Colors.white),
        );
      case 3:
        return const CircleAvatar(
          backgroundColor: Colors.orange,
          child: Icon(Icons.sick, color: Colors.white),
        );
      default:
        return const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.help_outline, color: Colors.white),
        );
    }
  }
}
