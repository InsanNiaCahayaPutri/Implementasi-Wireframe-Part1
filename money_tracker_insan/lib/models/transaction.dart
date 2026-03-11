class TransactionModel {
  String title;
  double amount;
  DateTime date;
  bool isIncome;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
  });
}
