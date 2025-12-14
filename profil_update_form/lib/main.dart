import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'theme.dart';

void main() {
  // Opsional: ubah warna default dari kode di sini sebelum run
  AppTheme.setColors(
    primary: Colors.purple.shade100, // ungu pastel lebih soft
    background: Colors.purple.shade50, // ungu sangat lembut
    inputFill: Colors.white,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Jika ingin mengganti tema dari kode runtime, panggil setState di sini setelah memanggil AppTheme.setColors(...)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Update Form',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(),
      home: const ProfilePage(),
    );
  }
}
