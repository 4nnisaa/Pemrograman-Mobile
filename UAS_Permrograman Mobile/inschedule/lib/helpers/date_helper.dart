import 'package:flutter/material.dart';

class DateHelper {
  static final List<String> _indonesianDays = [
    'Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'
  ];

  static final List<String> _indonesianMonths = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];

  static String getCurrentDay() {
    final now = DateTime.now();
    return _indonesianDays[now.weekday % 7];
  }

  static String getIndonesianDayName(DateTime date) {
    return _indonesianDays[date.weekday % 7];
  }

  static String getIndonesianMonthName(int month) {
    if (month >= 1 && month <= 12) {
      return _indonesianMonths[month - 1];
    }
    return '';
  }

  static String formatTimeFromTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay? parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
    } catch (e) {
      print('Error parsing time: $e');
    }
    return null;
  }

  static String formatFullIndonesianDate(DateTime date) {
    final dayName = getIndonesianDayName(date);
    final monthName = getIndonesianMonthName(date.month);
    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  static List<TimeOfDay> parseTimeRange(String timeRange) {
    try {
      final parts = timeRange.split('-');
      if (parts.length == 2) {
        final startTime = parseTime(parts[0].trim());
        final endTime = parseTime(parts[1].trim());
        if (startTime != null && endTime != null) {
          return [startTime, endTime];
        }
      }
    } catch (e) {
      print('Error parsing time range: $e');
    }
    return [const TimeOfDay(hour: 8, minute: 0), const TimeOfDay(hour: 10, minute: 0)];
  }

  static bool isValidTimeRange(TimeOfDay start, TimeOfDay end) {
    if (end.hour > start.hour) return true;
    if (end.hour == start.hour && end.minute > start.minute) return true;
    return false;
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  static String getCurrentDateTime() {
    final now = DateTime.now();
    final dayName = getIndonesianDayName(now);
    final monthName = getIndonesianMonthName(now.month);
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    
    return '$dayName, ${now.day} $monthName ${now.year} • $hour:$minute';
  }
}