import '../models/transaction.dart';

class TransactionService {
  static final TransactionService instance = TransactionService._internal();

  factory TransactionService() => instance;

  TransactionService._internal();

  final List<TransactionModel> _transactions = [];

  List<TransactionModel> getTransactions() {
    return _transactions;
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
  }

  void deleteTransaction(TransactionModel transaction) {
    _transactions.remove(transaction);
  }

  double getBalance() {
    double total = 0;

    for (var t in _transactions) {
      if (t.isIncome) {
        total += t.amount;
      } else {
        total -= t.amount;
      }
    }

    return total;
  }
}
