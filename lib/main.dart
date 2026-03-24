import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/onboarding.dart';
import 'package:expense_tracker/pages/signup.dart';
import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/add_expense.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AddExpense(),
      co
    );
  }
}
