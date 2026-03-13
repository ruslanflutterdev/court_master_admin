import 'package:flutter/material.dart';

class ScheduleSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScheduleSaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed,
      child: const Text('Сохранить'),
    );
  }
}
