import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isIncomeSelected = true;

  @override
  Widget build(BuildContext context) {
    final service = TransactionService.instance;
    final transactions = service.getTransactions();

    final filtered = transactions
        .where((t) => t.isIncome == isIncomeSelected)
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 TITLE
              const Text(
                "Statistik",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 🔹 CARD ATAS (SUMMARY / CHART PLACEHOLDER)
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.arrow_outward),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 TOGGLE BUTTON (Keluar / Masuk)
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isIncomeSelected = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: !isIncomeSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(child: Text("Keluar")),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isIncomeSelected = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isIncomeSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(child: Text("Masuk")),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 DIVIDER + ICON
              Row(
                children: [
                  const Icon(Icons.arrow_downward),
                  const SizedBox(width: 10),
                  Expanded(child: Divider(color: Colors.black)),
                ],
              ),

              const SizedBox(height: 15),

              // 🔹 LIST DATA
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text("Belum ada data"))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final t = filtered[index];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  t.isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: t.isIncome ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: Text(t.title)),
                                Text(
                                  "${t.isIncome ? '+' : '-'} Rp ${t.amount.toStringAsFixed(0)}",
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
