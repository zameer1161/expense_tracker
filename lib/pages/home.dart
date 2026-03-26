import 'package:expense_tracker/pages/add_expense.dart';
import 'package:expense_tracker/pages/login.dart';
import 'package:expense_tracker/pages/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    "Grocery": Colors.red, // 🔥 as you wanted
    "Travel": Colors.orange,
    "Food": Colors.purple, // 🔥 different color
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Income: ₹${totalIncome.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.green),
                    ),
                    Text(
                      "Expense: ₹${totalExpense.toStringAsFixed(0)}",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Center(
                  child: ElevatedButton(
                    onPressed: fetchData,
                    child: const Text("Refresh"),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  showIncome ? "Income History" : "Expense History",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 LIST WITH COLORS
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: currentList.length,
                  itemBuilder: (context, index) {
                    var data =
                        currentList[index].data() as Map<String, dynamic>;

                    double amount = (data['amount'] as num).toDouble();

                    String category = data['category'] ?? 'Others';
                    String description = data['description'] ?? '';

                    Timestamp timestamp = data['date'];
                    DateTime date = timestamp.toDate();

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              categoryColors[category] ?? Colors.grey,
                          child: Icon(
                            showIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.white,
                          ),
                        ),

                        title: Text("₹${amount.toStringAsFixed(0)}"),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!showIncome) Text(category),
                            if (description.isNotEmpty) Text(description),
                            Text(
                              "${date.day}/${date.month}/${date.year}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),

                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteEntry(currentList[index].id),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(username),
          ],
        ),
        Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: CircleAvatar(
              radius: 30,
              backgroundImage: userimage.isNotEmpty
                  ? NetworkImage(userimage)
                  : const AssetImage('images/boy1.jpg') as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }

  /// 🔥 TOGGLE
  Widget toggleUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text("Expense"),
          selected: !showIncome,
          onSelected: (_) {
            setState(() => showIncome = false);
            fetchData();
          },
        ),
        const SizedBox(width: 10),
        ChoiceChip(
          label: const Text("Income"),
          selected: showIncome,
          onSelected: (_) {
            setState(() => showIncome = true);
            fetchData();
          },
        ),
      ],
    );
  }

  /// 🔥 FILTER
  Widget filterUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ["day", "week", "month"].map((e) {
        return GestureDetector(
          onTap: () {
            setState(() => filter = e);
            fetchData();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: filter == e ? Colors.orange : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(e.toUpperCase()),
          ),
        );
      }).toList(),
    );
  }

  /// 🔥 CARD (COLORFUL PIE)
  Widget cardUI() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(showIncome ? "Income" : "Expenses"),

          Row(
            children: [
              const Icon(Icons.currency_rupee),
              Text(
                (showIncome ? totalIncome : totalExpense).toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: showIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),

          if (!showIncome) ...[
            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sectionsSpace: 3,
                  sections: categoryData.entries.map((entry) {
                    double percent = totalExpense == 0
                        ? 0
                        : (entry.value / totalExpense) * 100;

                    Color color = categoryColors[entry.key] ?? Colors.grey;

                    return PieChartSectionData(
                      value: entry.value,
                      color: color,
                      radius: 55,
                      title: percent == 0
                          ? ""
                          : "${percent.toStringAsFixed(0)}%",
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 15,
              children: categoryColors.entries.map((entry) {
                return legendItem(entry.value, entry.key);
              }).toList(),
            ),
          ],
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
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: userimage.isNotEmpty
                      ? NetworkImage(userimage)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(username),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>Profile()))
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Expense'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddExpense()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
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
    );
  }
}

