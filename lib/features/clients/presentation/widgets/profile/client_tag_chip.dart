import 'package:flutter/material.dart';

class ClientTagChip extends StatelessWidget {
  final String tag;

  const ClientTagChip({super.key, required this.tag});

  Color get _tagColor {
    final lowerTag = tag.toLowerCase();
    if (lowerTag.contains('vip')) return Colors.purple;
    if (lowerTag.contains('проблемный') || lowerTag.contains('должник')) {
      return Colors.red;
    }
    if (lowerTag.contains('корпорат')) return Colors.indigo;
    return Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tag, style: const TextStyle(color: Colors.white)),
      backgroundColor: _tagColor,
    );
  }
}
