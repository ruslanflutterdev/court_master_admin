import 'package:flutter/material.dart';

class ScheduleColorHelper {
  static Color getColorForEventType(String type, {String? dbColorHex}) {
    if (type == 'maintenance') return Colors.grey.shade600;
    if (type == 'tournament') return Colors.red.shade400;

    if (dbColorHex != null &&
        dbColorHex.length == 7 &&
        dbColorHex.startsWith('#')) {
      try {
        return Color(
          int.parse(dbColorHex.substring(1, 7), radix: 16) + 0xFF000000,
        );
      } catch (_) {}
    }

    switch (type) {
      case 'individual':
        return Colors.blue;
      case 'group':
        return Colors.green;
      case 'rent':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }
}
