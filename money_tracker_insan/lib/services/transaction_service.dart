import '../models/transaction.dart';

class TransactionService {
  // singleton (biar bisa dipakai di semua screen)
  static final TransactionService instance = TransactionService._internal();

  factory TransactionService() {
    return instance;
  }

  TransactionService._internal();

  final List<TransactionModel> _transactions = [];

  List<TransactionModel> getTransactions() {
    return _transactions;
  }

  void addTransaction(TransactionModel transaction) {
    _transactions.add(transaction);
  }

  double getBalance() {
    double balance = 0;

    for (var t in _transactions) {
      if (t.isIncome) {
        balance += t.amount;
      } else {
        balance -= t.amount;
      }
    }

    return balance;
  }
}
