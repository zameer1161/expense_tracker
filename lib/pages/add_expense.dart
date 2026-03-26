import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  String selectedCategory = "Shopping";

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  bool isLoading = false;

  /// 🔥 SAVE EXPENSE
  Future<void> saveExpense() async {

    if (amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter amount")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {

      String uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('expenses').add({
        'amount': double.parse(amountController.text),
        'category': selectedCategory,
        'description': descriptionController.text,
        'date': Timestamp.fromDate(selectedDate), // 🔥 FIXED
        'uid': uid,
        'createdAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense Added")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  /// 📅 DATE PICKER
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
      body: SafeArea( // 🔥 ADDED
        child: SingleChildScrollView( // 🔥 ADDED
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Add Expense",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                ),

                const Divider(),
                const SizedBox(height: 20),

                /// AMOUNT
                const Text("Amount"),
                const SizedBox(height: 10),

                inputField(
                  controller: amountController,
                  hint: "Enter amount",
                  icon: Icons.currency_rupee,
                  isNumber: true,
                ),

                const SizedBox(height: 20),

                /// CATEGORY
                const Text("Category"),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10, // 🔥 better responsive
                  children: [
                    categoryChip("Shopping"),
                    categoryChip("Grocery"),
                    categoryChip("Travel"),
                    categoryChip("Food"),
                    categoryChip("Others"),
                  ],
                ),

                const SizedBox(height: 20),

                /// DESCRIPTION
                const Text("Description"),
                const SizedBox(height: 10),

                inputField(
                  controller: descriptionController,
                  hint: "Add note",
                  icon: Icons.notes,
                ),

                const SizedBox(height: 20),

                /// DATE
                const Text("Date"),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 10),
                        Text(
                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// SAVE BUTTON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text("Save",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

                    GestureDetector(
                      onTap: isLoading ? null : saveExpense,
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(60)),
                        child: isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : const Icon(Icons.check, color: Colors.white),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔧 INPUT FIELD
  Widget inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          hintText: hint,
        ),
      ),
    );
  }

  /// CATEGORY CHIP
  Widget categoryChip(String title) {
    final isSelected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}