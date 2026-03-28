import 'package:flutter/material.dart';

class CoachSaveButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const CoachSaveButton({super.key, required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.save, color: Colors.white),
        label: const Text(
          'Сохранить налоги',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
      ),
    );
  }
}
