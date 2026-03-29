import 'package:expense_tracker/pages/add_expense.dart';
import 'package:expense_tracker/pages/login.dart';
import 'package:expense_tracker/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/pages/edit_income.dart';
import 'package:expense_tracker/pages/edit_expense.dart';
import 'package:expense_tracker/pages/add_income.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double totalExpense = 0;
  double totalIncome = 0;

  bool showIncome = false;
  String filter = "month";

  List<QueryDocumentSnapshot> expenseEntries = [];
  List<QueryDocumentSnapshot> incomeEntries = [];

  /// 🔥 CATEGORY COLORS (UPDATED)
  final Map<String, Color> categoryColors = {
    "Shopping": Colors.blue,
    "Grocery": Colors.red,
    "Travel": Colors.orange,
    "Food": Colors.purple,
    "Others": Colors.green,
  };

  Map<String, double> categoryData = {
    "Shopping": 0,
    "Grocery": 0,
    "Travel": 0,
    "Food": 0,
    "Others": 0,
  };

  String username = "";
  String userimage = "";

  /// 🔥 USER DATA
  Future<void> getuserdata() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    setState(() {
      username = doc['name'] ?? 'User';
      userimage = doc['image'] ?? '';
    });
  }

  /// 🔥 FETCH DATA
  Future<void> fetchData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DateTime now = DateTime.now();
    DateTime startDate;

    if (filter == "day") {
      startDate = DateTime(now.year, now.month, now.day);
    } else if (filter == "week") {
      startDate = now.subtract(const Duration(days: 7));
    } else {
      startDate = DateTime(now.year, now.month, 1);
    }

    final snapshot = await FirebaseFirestore.instance
        .collection(showIncome ? 'income' : 'expenses')
        .where('uid', isEqualTo: uid)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .get();

    double total = 0;

    Map<String, double> tempData = {
      "Shopping": 0,
      "Grocery": 0,
      "Travel": 0,
      "Food": 0,
      "Others": 0,
    };

    for (var doc in snapshot.docs) {
      double amount = (doc['amount'] as num).toDouble();
      total += amount;

      if (!showIncome) {
        String category = doc['category'] ?? "Others";

        if (tempData.containsKey(category)) {
          tempData[category] = tempData[category]! + amount;
        } else {
          tempData["Others"] = tempData["Others"]! + amount;
        }
      }
    }

    setState(() {
      if (showIncome) {
        totalIncome = total;
        incomeEntries = snapshot.docs;
        expenseEntries = [];
      } else {
        totalExpense = total;
        categoryData = tempData;
        expenseEntries = snapshot.docs;
        incomeEntries = [];
      }
    });
  }

  /// 🔥 DELETE
  Future<void> deleteEntry(String id) async {
    await FirebaseFirestore.instance
        .collection(showIncome ? 'income' : 'expenses')
        .doc(id)
        .delete();

    fetchData();
  }

  /// 🔥 EDIT - Separate pages for income and expense
  Future<void> editEntry(String id, Map<String, dynamic> data) async {
    if (showIncome) {
      // Edit Income
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditIncome(
            entryId: id,
            entryData: data,
          ),
        ),
      );
    } else {
      // Edit Expense
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EditExpense(
            entryId: id,
            entryData: data,
          ),
        ),
      );
    }
    fetchData();
  }

  /// 🔥 ADD INCOME - Using separate AddIncome page
  /// 🔥 ADD INCOME
Future<void> addIncome() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const AddIncome()),
  );
  if (result == true) {
    fetchData(); // Refresh data after adding
  }
}

  /// 🔥 ADD EXPENSE - Using separate AddExpense page
  Future<void> addExpense() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddExpense()),
    );
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    getuserdata();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List currentList = showIncome ? incomeEntries : expenseEntries;

    return Scaffold(
      drawer: drawerUI(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerUI(),
                const SizedBox(height: 20),

                toggleUI(),
                const SizedBox(height: 10),

                filterUI(),
                const SizedBox(height: 20),

                cardUI(),
                const SizedBox(height: 20),

                // Add Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: addExpense,
                        icon: const Icon(Icons.trending_down, size: 18),
                        label: const Text("Add Expense"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade50,
                          foregroundColor: Colors.red.shade700,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: addIncome,
                        icon: const Icon(Icons.trending_up, size: 18),
                        label: const Text("Add Income"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade50,
                          foregroundColor: Colors.green.shade700,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.green.shade200),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade50, Colors.red.shade50],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.trending_up, color: Colors.green.shade700, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Income", style: TextStyle(fontSize: 12)),
                              Text(
                                "₹${totalIncome.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(width: 1, height: 40, color: Colors.grey.shade300),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.trending_down, color: Colors.red.shade700, size: 20),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Expense", style: TextStyle(fontSize: 12)),
                              Text(
                                "₹${totalExpense.toStringAsFixed(0)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton.icon(
                    onPressed: fetchData,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Refresh"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade50,
                      foregroundColor: Colors.indigo.shade700,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      showIncome ? "Income History" : "Expense History",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${currentList.length} items",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.indigo.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔥 LIST WITH EDIT BUTTON
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    var data = currentList[index].data() as Map<String, dynamic>;

                    double amount = (data['amount'] as num).toDouble();
                    String category = data['category'] ?? 'Others';
                    String description = data['description'] ?? '';
                    Timestamp timestamp = data['date'];
                    DateTime date = timestamp.toDate();

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: categoryColors[category] ?? Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              showIncome ? Icons.arrow_downward : Icons.arrow_upward,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          title: Text(
                            "₹${amount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!showIncome)
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (description.isNotEmpty)
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              Text(
                                "${date.day}/${date.month}/${date.year}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Colors.indigo.shade400,
                                  size: 20,
                                ),
                                onPressed: () => editEntry(currentList[index].id, data),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade400,
                                  size: 20,
                                ),
                                onPressed: () => deleteEntry(currentList[index].id),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 HEADER
  Widget headerUI() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back,",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                username,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundImage: userimage.isNotEmpty
                      ? NetworkImage(userimage)
                      : const AssetImage('images/boy1.jpg') as ImageProvider,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 TOGGLE
  Widget toggleUI() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => showIncome = false);
                fetchData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !showIncome ? Colors.indigo.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Expense",
                    style: TextStyle(
                      color: !showIncome ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => showIncome = true);
                fetchData();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: showIncome ? Colors.indigo.shade600 : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Income",
                    style: TextStyle(
                      color: showIncome ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 FILTER
  Widget filterUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ["day", "week", "month"].map((e) {
        bool isSelected = filter == e;
        return GestureDetector(
          onTap: () {
            setState(() => filter = e);
            fetchData();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.indigo.shade600 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: Text(
              e.toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 🔥 CARD (COLORFUL PIE)
  Widget cardUI() {
    // Filter out zero value categories
    List<MapEntry<String, double>> nonZeroCategories = 
        categoryData.entries.where((entry) => entry.value > 0).toList();
    bool hasData = totalExpense > 0 && nonZeroCategories.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            showIncome ? "Income Overview" : "Expense Breakdown",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.currency_rupee, size: 28),
              Text(
                (showIncome ? totalIncome : totalExpense).toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: showIncome ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ],
          ),

          if (!showIncome && hasData) ...[
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sectionsSpace: 2,
                  sections: nonZeroCategories.map((entry) {
                    double percent = (entry.value / totalExpense) * 100;
                    Color color = categoryColors[entry.key] ?? Colors.grey;
                    return PieChartSectionData(
                      value: entry.value,
                      color: color,
                      radius: 55,
                      title: percent >= 5 ? "${percent.toStringAsFixed(0)}%" : "",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: nonZeroCategories.map((entry) {
                double percent = (entry.value / totalExpense) * 100;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (categoryColors[entry.key] ?? Colors.grey).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: categoryColors[entry.key] ?? Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        " (${percent.toStringAsFixed(0)}%)",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
          
          if (!showIncome && !hasData)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Text(
                  "No expenses to display",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  /// DRAWER
  Widget drawerUI() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade700, Colors.purple.shade700],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: userimage.isNotEmpty
                          ? NetworkImage(userimage)
                          : null,
                      child: userimage.isEmpty
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, color: Colors.indigo),
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Profile()));
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.trending_down, color: Colors.red),
              ),
              title: const Text('Add Expense'),
              onTap: addExpense,
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.trending_up, color: Colors.green),
              ),
              title: const Text('Add Income'),
              onTap: addIncome,
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.logout, color: Colors.red),
              ),
              title: const Text("Logout"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}