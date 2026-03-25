import 'package:flutter/material.dart';

class PaymentHelper {
  static const String typeIncome = 'INCOME';
  static const String typeExpense = 'EXPENSE';
  static const String typeRefund = 'REFUND';

  static const String methodCash = 'CASH';
  static const String methodCard = 'CARD';
  static const String methodTransfer = 'TRANSFER';
  static const String methodQr = 'QR';
  static const String methodSbp = 'SBP';
  static const String methodDeposit = 'DEPOSIT';

  static String getTypeName(String type) {
    switch (type.toUpperCase()) {
      case typeIncome:
        return 'Приход (Оплата)';
      case typeExpense:
        return 'Расход (Списание)';
      case typeRefund:
        return 'Возврат';
      default:
        return 'Неизвестно';
    }
  }

  static String getMethodName(String method) {
    switch (method.toUpperCase()) {
      case methodCash:
        return 'Наличные';
      case methodCard:
        return 'Терминал / Карта';
      case methodTransfer:
        return 'Перевод';
      case methodQr:
        return 'QR-код';
      case methodSbp:
        return 'СБП';
      case methodDeposit:
        return 'Депозит (Баланс)';
      default:
        return 'Неизвестно';
    }
  }

  static IconData getMethodIcon(String method) {
    switch (method.toUpperCase()) {
      case methodCash:
        return Icons.money;
      case methodCard:
        return Icons.credit_card;
      case methodTransfer:
        return Icons.account_balance;
      case methodQr:
        return Icons.qr_code_scanner;
      case methodSbp:
        return Icons.account_balance_wallet;
      case methodDeposit:
        return Icons.wallet;
      default:
        return Icons.payment;
    }
  }

  static Color getTypeColor(String type) {
    switch (type.toUpperCase()) {
      case typeIncome:
        return Colors.green;
      case typeExpense:
        return Colors.red;
      case typeRefund:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
