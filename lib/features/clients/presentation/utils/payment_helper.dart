import 'package:flutter/material.dart';

class PaymentHelper {
  static String getTypeName(int type) {
    switch (type) {
      case 1:
        return 'Пополнение (Оплата)';
      case 2:
        return 'Списание';
      case 3:
        return 'Возврат';
      default:
        return 'Неизвестно';
    }
  }

  static String getMethodName(int method) {
    switch (method) {
      case 1:
        return 'Наличные';
      case 2:
        return 'Карта / Терминал';
      case 3:
        return 'Перевод / СБП';
      default:
        return 'Неизвестно';
    }
  }

  static IconData getMethodIcon(int method) {
    switch (method) {
      case 1:
        return Icons.money;
      case 2:
        return Icons.credit_card;
      case 3:
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  static Color getTypeColor(int type) {
    switch (type) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
