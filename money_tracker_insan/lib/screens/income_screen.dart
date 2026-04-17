import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = TransactionService.instance;
    final incomes =
        service.getTransactions().where((t) => t.isIncome).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Pemasukan")),
      body: ListView.builder(
        itemCount: incomes.length,
        itemBuilder: (context, index) {
          final t = incomes[index];

          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.arrow_downward, color: Colors.white),
            ),
            title: Text(t.title),
            trailing: Text("+ Rp ${t.amount.toStringAsFixed(0)}"),
          );
        },
      ),
    );
  }
}