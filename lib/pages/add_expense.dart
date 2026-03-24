import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {

  String selectedCategory = "Shopping";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Add Expense",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),

                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),

            const Divider(),
            const SizedBox(height: 20),

            /// AMOUNT FIELD
            const Text(
              "Amount",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.currency_rupee),
                  hintText: "Enter amount",
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY
            const Text(
              "Category",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
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
            const Text(
              "Description",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: const TextField(
                maxLines: 2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Add note (optional)",
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DATE
            const Text(
              "Date",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: const Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 10),
                  Text("Select Date"),
                ],
              ),
            ),

            const Spacer(),

            /// ADD BUTTON (Same style as your UI)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Save",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                ),

                GestureDetector(
                  onTap: () {
                    // Save expense logic here
                  },
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(60)),
                    child: const Icon(Icons.check,
                        color: Colors.white),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// CATEGORY CHIP WIDGET
  Widget categoryChip(String title) {
    final isSelected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = title;
        });
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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