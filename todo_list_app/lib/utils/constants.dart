import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'My Purple Todo';
  static const String storageKey = 'todos';
  
  // Filter types
  static const String filterAll = 'all';
  static const String filterDone = 'done';
  static const String filterNotDone = 'notyet';
  
  // Messages
  static const String emptyTodoMessage = 'Yay! Tidak ada tugas~';
  static const String addTodoTitle = 'Buat Tugas Baru ✨';
  static const String editTodoTitle = 'Edit Tugas ✏️';
  static const String cancelText = 'Batal';
  static const String saveText = 'Simpan';
  static const String deleteText = 'Hapus';
  static const String confirmDeleteTitle = 'Hapus Tugas?';
  static const String confirmDeleteMessage = 'Tugas ini akan dihapus permanen!';
}

class AppColors {
  static const primaryColor = Color(0xFF9C27B0); // Ungu utama cute 💜
  static const primaryLight = Color(0xFFE1BEE7); // Ungu pastel
  static const primaryDark = Color(0xFF6A0080); // Ungu gelap elegan
  static const accentColor = Color(0xFFCE93D8); // Ungu soft
  static const dangerColor = Color(0xFFE53935);
  static const successColor = Color(0xFF43A047);
  static const backgroundColor = Color(0xFFF8EAFE); // Background ungu pastel cute
  static const cardColor = Colors.white;
  static const textColor = Color(0xFF4A148C); // Ungu gelap untuk teks
}

class AppGradients {
  static const primaryGradient = LinearGradient(
    colors: [
      Color(0xFFBA68C8), // Ungu manis
      Color(0xFF9C27B0), // Ungu utama
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xFFAB47BC), // Ungu cerah
      Color(0xFF8E24AA), // Ungu lebih gelap
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}