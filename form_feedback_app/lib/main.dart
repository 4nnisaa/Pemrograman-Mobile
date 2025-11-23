import 'package:flutter/material.dart';
import 'feedback_form_page.dart';

void main() {
  runApp(const FormFeedbackApp());
}

class FormFeedbackApp extends StatelessWidget {
  const FormFeedbackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Feedback App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // 🎨 Skema warna dengan nuansa pink lembut
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE91E63), // pink utama
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE91E63), // pink elegan
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 4,
          shadowColor: Colors.black26,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      ),

      // 🌸 Bungkus halaman utama dengan Container gradasi pink-putih
      home: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8BBD0), // pink muda
              Colors.white,       // putih
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const FeedbackFormPage(),
      ),
    );
  }
}
