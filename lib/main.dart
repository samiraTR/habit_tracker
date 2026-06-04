import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit_tracker/Features/Screens/dashboard.dart';
import 'package:habit_tracker/Features/Screens/report_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FF),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C77F2),
          brightness: Brightness.light,
          primary: const Color(0xFF7C77F2),
          secondary: const Color(0xFF5C6BC0),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E2A47),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Color(0xFF1E2A47),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF33415C)),
          bodyMedium: TextStyle(color: Color(0xFF5F6E8A)),
          titleLarge: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      home: const ReportScreen(),
    );
  }
}
