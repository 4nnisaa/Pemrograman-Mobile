import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _isDarkMode = false;

  ThemeProvider({bool isDarkMode = false}) {
    _isDarkMode = isDarkMode;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;

  Future<void> toggleTheme(bool isDark) async {
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    
    // Save preference to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    
    notifyListeners();
  }

  Future<void> loadThemePreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool('isDarkMode') ?? false;
    _isDarkMode = isDark;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}