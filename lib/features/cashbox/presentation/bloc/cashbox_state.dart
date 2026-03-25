abstract class CashboxState {
  const CashboxState();
}

class CashboxInitial extends CashboxState {
  const CashboxInitial();
}

class CashboxLoading extends CashboxState {
  const CashboxLoading();
}

class CashboxLoaded extends CashboxState {
  final Map<String, dynamic> status;
  const CashboxLoaded(this.status);
}

class CashboxShiftClosed extends CashboxState {
  final Map<String, dynamic> result;
  const CashboxShiftClosed(this.result);
}

class CashboxError extends CashboxState {
  final String message;
  const CashboxError(this.message);
}
