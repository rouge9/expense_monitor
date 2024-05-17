import 'package:expense_monitor/screens/home/views/home_screen.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Monitor',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            surface: Color(0xfff3f4f6),
            onSurface: Colors.black,
            primary: Color(0xFF00B2E7),
            secondary: Color(0xFFE064F7),
            tertiary: Color(0xFFFF8D6C),
            outline: Colors.grey),
      ),
      home: const HomeScreen(),
    );
  }
}
