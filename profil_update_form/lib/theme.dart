import 'package:flutter/material.dart';

class AppTheme {
  // Warna utama bisa diubah langsung di sini
  static Color primaryColor = const Color(0xFFE4B7FF);
  static Color backgroundColor = const Color(0xFFF5E8FF);
  static Color inputFillColor = const Color(0xFFF0D9FF);

  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: createMaterialColor(primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Helper untuk bikin MaterialColor dari Color
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) strengths.add(0.1 * i);
    for (var strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // Fungsi ganti warna langsung dari kode
  static void setColors({
    Color? primary,
    Color? background,
    Color? inputFill,
  }) {
    if (primary != null) primaryColor = primary;
    if (background != null) backgroundColor = background;
    if (inputFill != null) inputFillColor = inputFill;
  }
}
