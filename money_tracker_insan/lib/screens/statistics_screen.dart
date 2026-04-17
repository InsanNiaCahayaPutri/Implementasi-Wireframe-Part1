import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/transaction_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isIncomeSelected = true;
  int selectedMonth = DateTime.now().month;

  // 🔹 FORMAT BULAN
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

  // 🔹 PIE CHART (BEDA MASUK & KELUAR)
  Widget buildPieChart(Map<String, double> grouped) {
    final total = grouped.values.fold(0.0, (sum, v) => sum + v);

    final incomeColors = [Colors.green, Colors.lightGreen, Colors.teal];

    final expenseColors = [Colors.red, Colors.orange, Colors.deepOrange];

    final colors = isIncomeSelected ? incomeColors : expenseColors;

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: grouped.isEmpty
              ? const Center(child: Text("Tidak ada data"))
              : PieChart(
                  PieChartData(
                    sections: List.generate(grouped.length, (index) {
                      final entry = grouped.entries.elementAt(index);

                      final percentage = ((entry.value / total) * 100)
                          .toStringAsFixed(1);

                      final color = colors[index % colors.length];

                      return PieChartSectionData(
                        value: entry.value,
                        title: "$percentage%",
                        radius: 60,
                        color: color,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
        ),

        const SizedBox(height: 20),

        // 🔹 LEGEND
        Column(
          children: List.generate(grouped.length, (index) {
            final entry = grouped.entries.elementAt(index);
            final color = colors[index % colors.length];

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    isIncomeSelected
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: color,
                  ),
                  const SizedBox(width: 8),

                  Expanded(child: Text(entry.key)),

                  Text(
                    "Rp ${entry.value.toStringAsFixed(0)}",
                    style: TextStyle(
                      color: isIncomeSelected ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
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
              Text(
                isIncomeSelected
                    ? "Statistik Pemasukan"
                    : "Statistik Pengeluaran",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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

              // 🔹 PIE CHART
              buildPieChart(grouped),

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
            ],
          ),
        ),
      ),
    );
  }
}
