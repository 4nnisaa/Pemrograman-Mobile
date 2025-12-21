import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/schedule.dart';

class ScheduleProvider with ChangeNotifier {
  List<Schedule> _schedules = [];
  bool _isLoading = false;
  String _filterDay = 'Semua';
  String? _error;
  bool _isOnline = false; // ❌ PERBAIKAN: Default false, nanti dicek koneksi
  bool _hasCheckedConnection = false; // ❌ PERBAIKAN: Flag untuk cek koneksi

  String? _currentUserId;

  // ✅ PERBAIKAN: Gunakan URL yang lebih sederhana
  static const String _firebaseUrl =
      'https://inschedule-e9cd0-default-rtdb.asia-southeast1.firebasedatabase.app';

  static const String _localStorageKey = 'inschedule_data';

  List<Schedule> get schedules => _schedules;
  bool get isLoading => _isLoading;
  String get filterDay => _filterDay;
  String? get error => _error;
  bool get isOnline => _isOnline;

  void setUserId(String? userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  void setFilterDay(String day) {
    _filterDay = day;
    notifyListeners();
  }

  List<Schedule> getFilteredSchedules(String searchQuery) {
    List<Schedule> filtered = _schedules;

    if (_filterDay != 'Semua') {
      filtered =
          filtered.where((schedule) => schedule.hari == _filterDay).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((schedule) =>
              schedule.matkul
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              schedule.dosen
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              schedule.ruang.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    filtered.sort((a, b) => a.jam.compareTo(b.jam));
    return filtered;
  }

  // ✅ PERBAIKAN: Method untuk cek koneksi internet
  Future<bool> _checkInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchFromAPI() async {
    // ✅ PERBAIKAN: Cek koneksi dulu
    if (!_hasCheckedConnection) {
      _isOnline = await _checkInternetConnection();
      _hasCheckedConnection = true;
    }

    // Jika offline, langsung load dari local storage
    if (!_isOnline) {
      await _loadFromLocalStorage();
      if (_schedules.isEmpty) {
        _error = 'Gagal mengambil data dari server. Menampilkan data offline.';
      }
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final url = '$_firebaseUrl/schedules.json';
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Schedule> loadedSchedules = [];

        if (data != null && data is Map) {
          data.forEach((id, scheduleData) {
            // Filter berdasarkan userId jika ada
            if (_currentUserId == null ||
                scheduleData['userId'] == null ||
                scheduleData['userId'] == _currentUserId) {
              loadedSchedules.add(Schedule.fromJson(scheduleData, id));
            }
          });
        }

        _schedules = loadedSchedules;
        await _saveToLocalStorage();
        _isOnline = true;
      } else {
        throw Exception('HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Log full error for debugging
      print('❌ Error fetching from API: $e');
      _isOnline = false;

      // Try load from local storage. Only show offline message if no local data.
      await _loadFromLocalStorage();
      if (_schedules.isEmpty) {
        _error = 'Gagal mengambil data dari server. Menampilkan data offline.';
      } else {
        _error = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSchedule({
    required String matkul,
    required String dosen,
    required String jam,
    required String ruang,
    required String hari,
  }) async {
    _isLoading = true;
    notifyListeners();

    final scheduleData = {
      'matkul': matkul,
      'dosen': dosen,
      'jam': jam,
      'ruang': ruang,
      'hari': hari,
      'userId': _currentUserId,
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      if (_isOnline) {
        final url = '$_firebaseUrl/schedules.json';
        final response = await http.post(
          Uri.parse(url),
          body: json.encode(scheduleData),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final responseData = json.decode(response.body);
          final String newId = responseData['name'] ??
              DateTime.now().millisecondsSinceEpoch.toString();

          final newSchedule = Schedule(
            id: newId,
            matkul: matkul,
            dosen: dosen,
            jam: jam,
            ruang: ruang,
            hari: hari,
            userId: _currentUserId,
          );

          _schedules.add(newSchedule);
          await _saveToLocalStorage();
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ Failed to add to Firebase: $e');
    }

    // Jika offline atau gagal, simpan ke local saja
    final newSchedule = Schedule(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      matkul: matkul,
      dosen: dosen,
      jam: jam,
      ruang: ruang,
      hari: hari,
      userId: _currentUserId,
    );

    _schedules.add(newSchedule);
    await _saveToLocalStorage();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateSchedule({
    required String id,
    required String matkul,
    required String dosen,
    required String jam,
    required String ruang,
    required String hari,
  }) async {
    _isLoading = true;
    notifyListeners();

    final scheduleData = {
      'matkul': matkul,
      'dosen': dosen,
      'jam': jam,
      'ruang': ruang,
      'hari': hari,
      'userId': _currentUserId,
    };

    try {
      if (_isOnline) {
        final url = '$_firebaseUrl/schedules/$id.json';
        final response = await http.put(
          Uri.parse(url),
          body: json.encode(scheduleData),
          headers: {'Content-Type': 'application/json'},
        ).timeout(const Duration(seconds: 10));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          final index = _schedules.indexWhere((s) => s.id == id);
          if (index != -1) {
            _schedules[index] = _schedules[index].copyWith(
              matkul: matkul,
              dosen: dosen,
              jam: jam,
              ruang: ruang,
              hari: hari,
            );
            await _saveToLocalStorage();
          }
          return;
        }
      }
    } catch (e) {
      print('⚠️ Failed to update in Firebase: $e');
    }

    final index = _schedules.indexWhere((s) => s.id == id);
    if (index != -1) {
      _schedules[index] = _schedules[index].copyWith(
        matkul: matkul,
        dosen: dosen,
        jam: jam,
        ruang: ruang,
        hari: hari,
      );
      await _saveToLocalStorage();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteSchedule(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (_isOnline) {
        final url = '$_firebaseUrl/schedules/$id.json';
        final response = await http
            .delete(Uri.parse(url))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode >= 200 && response.statusCode < 300) {
          _schedules.removeWhere((schedule) => schedule.id == id);
          await _saveToLocalStorage();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
    } catch (e) {
      print('⚠️ Failed to delete from Firebase: $e');
    }

    _schedules.removeWhere((schedule) => schedule.id == id);
    await _saveToLocalStorage();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schedulesJson =
          _schedules.map((schedule) => schedule.toJson()).toList();
      await prefs.setString(_localStorageKey, json.encode(schedulesJson));
    } catch (e) {
      print('❌ Error saving to local storage: $e');
    }
  }

  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_localStorageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _schedules = jsonList.map((json) {
          return Schedule.fromJson(
              json, DateTime.now().millisecondsSinceEpoch.toString());
        }).toList();
      } else {
        _schedules = [];
      }
    } catch (e) {
      print('❌ Error loading from local storage: $e');
      _schedules = [];
    }
  }

  Map<String, int> getStatistics() {
    final Map<String, int> stats = {
      'Senin': 0,
      'Selasa': 0,
      'Rabu': 0,
      'Kamis': 0,
      'Jumat': 0,
      'Sabtu': 0,
      'Minggu': 0,
    };

    for (final schedule in _schedules) {
      if (stats.containsKey(schedule.hari)) {
        stats[schedule.hari] = stats[schedule.hari]! + 1;
      }
    }

    return stats;
  }

  int getTotalSchedules() => _schedules.length;

  int getTodaySchedules(String today) {
    return _schedules.where((schedule) => schedule.hari == today).length;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void setOnlineStatus(bool status) {
    _isOnline = status;
    _hasCheckedConnection = true;
    notifyListeners();
  }

  // ✅ PERBAIKAN: Method untuk refresh status koneksi
  Future<void> refreshConnection() async {
    _hasCheckedConnection = false;
    await fetchFromAPI();
  }

  // ✅ PERBAIKAN: Reset data saat user logout / berganti akun
  Future<void> resetForNewUser() async {
    _schedules = [];
    _filterDay = 'Semua';
    _error = null;
    _currentUserId = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey(_localStorageKey)) {
        await prefs.remove(_localStorageKey);
      }
    } catch (e) {
      print('❌ Error clearing user local storage: $e');
    }

    notifyListeners();
  }
}
