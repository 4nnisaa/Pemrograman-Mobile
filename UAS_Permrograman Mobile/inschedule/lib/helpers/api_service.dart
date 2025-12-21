import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 
      'https://inschedule-e9cd0-default-rtdb.asia-southeast1.firebasedatabase.app';
  
  static const String schedulesEndpoint = '/schedules.json';
  
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<bool> checkInternetConnection() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> fetchSchedules() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$schedulesEndpoint'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load schedules: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> addSchedule(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$schedulesEndpoint'),
        headers: headers,
        body: json.encode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add schedule: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateSchedule(String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/schedules/$id.json'),
        headers: headers,
        body: json.encode(data),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update schedule: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> deleteSchedule(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/schedules/$id.json'),
        headers: headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete schedule: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}