import 'package:flutter/material.dart';
import '../services/transaction_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isIncomeSelected = true;
  int selectedMonth = DateTime.now().month;

  // 🔹 FORMAT BULAN MANUAL
  String getMonthName(int month) {
    const months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return months[month - 1];
  }

  // 🔹 GRAFIK SEDERHANA
  Widget buildSimpleChart(Map<String, double> data) {
    double max = 0;
    for (var v in data.values) {
      if (v > max) max = v;
    }

    return Column(
      children: data.entries.map((entry) {
        double percent = max == 0 ? 0 : entry.value / max;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key),
              const SizedBox(height: 5),
              Container(
                height: 10,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isIncomeSelected ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = TransactionService.instance;
    final transactions = service.getTransactions();

    // 🔹 FILTER
    final filtered = transactions.where((t) {
      return t.isIncome == isIncomeSelected && t.date.month == selectedMonth;
    }).toList();

    // 🔹 TOTAL
    double total = filtered.fold(0, (sum, t) => sum + t.amount);

    // 🔹 GROUP
    Map<String, double> grouped = {};
    for (var t in filtered) {
      grouped[t.title] = (grouped[t.title] ?? 0) + t.amount;
    }

    // 🔹 INSIGHT
    String topCategory = grouped.isEmpty
        ? "-"
        : grouped.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Statistik",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // 🔹 CARD TOTAL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isIncomeSelected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isIncomeSelected
                          ? "Total Pemasukan"
                          : "Total Pengeluaran",
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rp ${total.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 FILTER BULAN
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(DateTime.now().year, selectedMonth),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );

                  if (picked != null) {
                    setState(() {
                      selectedMonth = picked.month;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            "${getMonthName(selectedMonth)} ${DateTime.now().year}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 TOGGLE
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

              // 🔹 GRAFIK
              buildSimpleChart(grouped),

              const SizedBox(height: 15),

              // 🔹 INSIGHT
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "Kategori terbesar: $topCategory",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 15),

              // 🔹 LIST
              Expanded(
                child: grouped.isEmpty
                    ? const Center(child: Text("Belum ada data"))
                    : ListView(
                        children: grouped.entries.map((entry) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 5),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: isIncomeSelected
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  child: Icon(
                                    isIncomeSelected
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: isIncomeSelected
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text("Rp ${entry.value.toStringAsFixed(0)}"),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
