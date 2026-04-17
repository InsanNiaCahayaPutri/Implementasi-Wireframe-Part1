import 'package:flutter/material.dart';
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

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              TextField(
                controller: title,
                decoration: const InputDecoration(
                  labelText: "Kategori / Nama Transaksi",
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal"),
              ),

              const SizedBox(height: 20),

              const Text(
                "Tanggal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                    style: const TextStyle(fontSize: 16),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      pickDate(context);
                    },
                    child: const Text("Pilih Tanggal"),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (title.text.isEmpty || amount.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Isi semua data terlebih dahulu"),
                        ),
                      );
                      return;
                    }

                    final newTransaction = TransactionModel(
                      title: title.text,
                      amount: double.parse(amount.text),
                      date: selectedDate,
                      isIncome: isIncome,
                    );

                    TransactionService.instance.addTransaction(newTransaction);

                    Navigator.pop(context, true); // kirim sinyal ke dashboard
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
