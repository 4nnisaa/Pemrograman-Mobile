import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveProfile(Map<String, String> profile) async {
    final prefs = await SharedPreferences.getInstance();
    profile.forEach((key, value) async {
      await prefs.setString(key, value);
    });
  }

  static Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'email': prefs.getString('email') ?? '',
      'phone': prefs.getString('phone') ?? '',
      'bio': prefs.getString('bio') ?? '',
      'dob': prefs.getString('dob') ?? '',
      'gender': prefs.getString('gender') ?? '',
      'photo': prefs.getString('photo') ?? '',
    };
  }
}
