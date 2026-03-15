import 'package:flutter/material.dart';

class SubscriptionHelper {
  static String getTypeName(int type) {
    switch (type) {
      case 1:
        return 'Разовое занятие';
      case 2:
        return 'Пакет занятий';
      case 3:
        return 'Безлимитный / Клубный';
      case 4:
        return 'Корт-часы';
      case 5:
        return 'Семейный';
      case 6:
        return 'Корпоративный';
      case 7:
        return 'Детские секции';
      default:
        return 'Неизвестный тип';
    }
  }

  static String getTypeDescription(int type) {
    switch (type) {
      case 1:
        return 'Оплата за одно посещение';
      case 2:
        return '6/8/12 занятий с ограничением срока';
      case 3:
        return 'Неограниченное время в месяц';
      case 4:
        return 'Аренда корта без тренера';
      case 5:
        return 'Несколько членов семьи';
      case 6:
        return 'Для юр. лиц с постоплатой';
      case 7:
        return 'Группы по возрасту и уровню';
      default:
        return '';
    }
  }

  static Color getTypeColor(int type) {
    switch (type) {
      case 1:
        return Colors.grey;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.purple;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.teal;
      case 6:
        return Colors.indigo;
      case 7:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  // Нужен ли ручной ввод количества занятий?
  // Для разового (1) всегда 1. Для безлимита (3) ставим 9999 под капотом.
  static bool requiresManualClassCount(int type) {
    return type != 1 && type != 3;
  }
}
