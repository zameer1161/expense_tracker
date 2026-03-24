import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isMonthSelected = true;

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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Zameer",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),

                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    "images/boy1.jpg",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),

            const Divider(),

            const SizedBox(height: 30),

            /// TITLE
            const Text(
              "Manage your\nExpenses",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 20),

            /// EXPENSE CARD
            Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Expenses",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),

                  Row(
                    children: const [
                      Icon(Icons.currency_rupee),
                      Text(
                        "5000",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    ],
                  ),

                  const Text(
                    "1 Mar 2026 - 30 Mar 2026",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  /// DONUT GRAPH
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 50,
                        sectionsSpace: 2,
                        sections: [

                          PieChartSectionData(
                            value: 40,
                            color: Colors.red,
                            title: "40%",
                            radius: 40,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),

                          PieChartSectionData(
                            value: 30,
                            color: Colors.green,
                            title: "30%",
                            radius: 40,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),

                          PieChartSectionData(
                            value: 20,
                            color: Colors.blue,
                            title: "20%",
                            radius: 40,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),

                          PieChartSectionData(
                            value: 10,
                            color: Colors.orange,
                            title: "10%",
                            radius: 40,
                            titleStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// LEGEND
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      LegendItem(color: Colors.red, text: "Shopping"),
                      LegendItem(color: Colors.green, text: "Grocery"),
                      LegendItem(color: Colors.blue, text: "Others"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// MONTH / YEAR BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMonthSelected = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMonthSelected
                          ? Colors.orange
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "This Month",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMonthSelected = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: !isMonthSelected
                          ? Colors.orange
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "This Year",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// INCOME & EXPENSE
            Row(
              children: [

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "+5000",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: const Column(
                      children: [
                        Text(
                          "Expenses",
                          style: TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "-3000",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            Container(     
              decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(60)),
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  Container(
                    padding : EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10)),
                    child: Image.asset('images/like.png',height: 50,width: 50,fit: BoxFit.cover,),
                    
                  ),
                  SizedBox(height: 20.0,),
                  Text('Your expenses plan looks good',style: TextStyle(color: Colors.white,fontSize: 20.0,fontWeight: FontWeight.w300),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// LEGEND WIDGET
class LegendItem extends StatelessWidget {

  final Color color;
  final String text;

  const LegendItem({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          height: 12,
          width: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 5),

        Text(text)

      ],
    );
  }
}