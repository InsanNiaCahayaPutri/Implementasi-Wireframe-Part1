import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController title = TextEditingController();
  final TextEditingController amount = TextEditingController();

  bool isIncome = true;
  DateTime selectedDate = DateTime.now();

  String selectedCategory = "";

  // KATEGORI INCOME
  final List<Map<String, dynamic>> incomeCategories = [
    {"name": "Gaji", "icon": Icons.attach_money, "color": Colors.green},
    {"name": "Bonus", "icon": Icons.card_giftcard, "color": Colors.blue},
    {"name": "Investasi", "icon": Icons.trending_up, "color": Colors.orange},
  ];

  // KATEGORI EXPENSE
  final List<Map<String, dynamic>> expenseCategories = [
    {"name": "Makan", "icon": Icons.fastfood, "color": Colors.red},
    {"name": "Transport", "icon": Icons.directions_car, "color": Colors.blue},
    {"name": "Belanja", "icon": Icons.shopping_bag, "color": Colors.purple},
    {"name": "Hiburan", "icon": Icons.movie, "color": Colors.orange},
  ];

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = isIncome ? incomeCategories : expenseCategories;

    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Transaksi")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Jenis Transaksi",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: const Text("Income"),
                      value: true,
                      groupValue: isIncome,
                      onChanged: (value) {
                        setState(() {
                          isIncome = value!;
                          selectedCategory = ""; // reset
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: const Text("Expense"),
                      value: false,
                      groupValue: isIncome,
                      onChanged: (value) {
                        setState(() {
                          isIncome = value!;
                          selectedCategory = ""; // reset
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const Text(
                "Kategori",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // GRID KATEGORI
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category["name"];

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category["name"];
                        title.text = category["name"];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? category["color"].withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? category["color"]
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(category["icon"], color: category["color"]),
                          const SizedBox(height: 5),
                          Text(
                            category["name"],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              // NOMINAL
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: "Nominal",
                  prefixText: "Rp ",
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Tanggal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  pickDate(context);
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
                            "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedCategory.isEmpty || amount.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Isi semua data")),
                      );
                      return;
                    }

                    final newTransaction = TransactionModel(
                      title: selectedCategory,
                      amount: double.parse(amount.text),
                      date: selectedDate,
                      isIncome: isIncome,
                    );

                    TransactionService.instance.addTransaction(newTransaction);

                    Navigator.pop(context, true);
                  },
                  child: const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
