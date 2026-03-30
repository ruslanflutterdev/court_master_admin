import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: const Center(
        child: Text(
          'Здесь будут настройки приложения\n(Реквизиты, цены, правила и т.д.)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
