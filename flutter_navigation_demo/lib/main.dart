import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo - Pink Theme',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFFD8BFF8), // ungu muda
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD8BFF8),     // ungu muda
          secondary: Color(0xFFE5CCFF),   // ganti pink -> ungu pastel
          background: Color(0xFFF7EFFF),  // ganti background pink -> ungu soft
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFD8BFF8), // ungu muda
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD8BFF8), // ungu muda
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}