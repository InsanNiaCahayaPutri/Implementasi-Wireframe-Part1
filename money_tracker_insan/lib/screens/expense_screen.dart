import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = TransactionService.instance;
    final expenses =
        service.getTransactions().where((t) => !t.isIncome).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Pengeluaran")),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final t = expenses[index];

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.arrow_upward, color: Colors.white),
            ),
            title: Text(t.title),
            trailing: Text("- Rp ${t.amount.toStringAsFixed(0)}"),
          );
        },
      ),
    );
  }
}