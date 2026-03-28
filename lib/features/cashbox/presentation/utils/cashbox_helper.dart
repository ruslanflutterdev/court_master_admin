class CashboxHelper {
  static int calculateTotal(Map<String, dynamic> data, String method) {
    if (data['transactions'] == null) return 0;
    final transactions = data['transactions'] as List;
    double total = 0;
    for (var tx in transactions) {
      final m = tx['type'] == 'income' ? 1 : -1;
      if (method == 'CASH' && tx['paymentMethod'] == 'CASH') {
        total += (tx['amount'] as num) * m;
      } else if (method == 'CARD' &&
          (tx['paymentMethod'] == 'CARD' ||
              tx['paymentMethod'] == 'QR' ||
              tx['paymentMethod'] == 'SBP')) {
        total += (tx['amount'] as num) * m;
      }
    }
    return total.toInt();
  }
}
