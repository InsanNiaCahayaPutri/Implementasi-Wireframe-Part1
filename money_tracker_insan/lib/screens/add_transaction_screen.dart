import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  final TextEditingController title = TextEditingController();
  final TextEditingController amount = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Transaksi")),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: "Kategori / Nama Transaksi",
              ),
            ),

            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Nominal"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
