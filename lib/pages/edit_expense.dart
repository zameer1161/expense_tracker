import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditExpense extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const EditExpense({super.key, required this.docId, required this.data});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {

  late TextEditingController amountController;
  late TextEditingController descriptionController;

  String selectedCategory = "Shopping";
  DateTime selectedDate = DateTime.now();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    amountController =
        TextEditingController(text: widget.data['amount'].toString());

    descriptionController =
        TextEditingController(text: widget.data['description']);

    selectedCategory = widget.data['category'];
    selectedDate = (widget.data['date'] as Timestamp).toDate();
  }

  /// 🔥 UPDATE FUNCTION
  Future<void> updateExpense() async {

    setState(() {
      isLoading = true;
    });

    try {

      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(widget.docId)
          .update({
        'amount': double.parse(amountController.text),
        'category': selectedCategory,
        'description': descriptionController.text,
        'date': selectedDate,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Updated")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  /// DATE PICKER
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Expense")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// AMOUNT
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY
            DropdownButton<String>(
              value: selectedCategory,
              items: ["Shopping", "Grocery", "Travel", "Food", "Others"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// DESCRIPTION
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
              ),
            ),

            const SizedBox(height: 20),

            /// DATE
            GestureDetector(
              onTap: pickDate,
              child: Text(
                "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              ),
            ),

            const SizedBox(height: 40),

            /// UPDATE BUTTON
            ElevatedButton(
              onPressed: isLoading ? null : updateExpense,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}