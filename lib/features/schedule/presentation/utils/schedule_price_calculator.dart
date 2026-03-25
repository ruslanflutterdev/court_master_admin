import 'package:flutter/material.dart';

class SchedulePriceCalculator {
  static int calculateDynamicPrice({
    required int basePrice,
    required DateTime date,
    required TimeOfDay startTime,
  }) {
    double multiplier = 1.0;

    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final isEvening = startTime.hour >= 18; // Пиковые часы

    if (isWeekend) {
      multiplier = 1.5; // +50%
    } else if (isEvening) {
      multiplier = 1.3; // +30%
    }

    return (basePrice * multiplier).round();
  }
}
