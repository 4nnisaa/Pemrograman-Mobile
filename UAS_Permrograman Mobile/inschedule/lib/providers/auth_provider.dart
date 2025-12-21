import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'schedule_provider.dart';

class AuthProvider with ChangeNotifier {
  // User state
  bool _isLoggedIn = false;
  String? _username;
  String? _email;
  String? _nim;
  String? _kelas;
  String? _userId;

  // App state
  bool _isLoading = false;
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get email => _email;
  String? get nim => _nim;
  String? get kelas => _kelas;
  String? get userId => _userId;
  bool get isLoading => _isLoading;
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;

  AuthProvider() {
    _loadAuthData();
  }

  // 🔧 LOAD AUTH DATA FROM SHARED PREFERENCES
  Future<void> _loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _username = prefs.getString('username');
      _email = prefs.getString('email');
      _nim = prefs.getString('nim') ?? '2201010045';
      _kelas = prefs.getString('kelas') ?? 'Teknik Informatika 5C';
      _userId = prefs.getString('userId');
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    } catch (e) {
      print('❌ Error loading auth data: $e');
    }
    notifyListeners();
  }

  // 🔧 SAVE AUTH DATA TO SHARED PREFERENCES
  Future<void> _saveAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', _isLoggedIn);
      if (_username != null) await prefs.setString('username', _username!);
      if (_email != null) await prefs.setString('email', _email!);
      if (_nim != null) await prefs.setString('nim', _nim!);
      if (_kelas != null) await prefs.setString('kelas', _kelas!);
      if (_userId != null) await prefs.setString('userId', _userId!);
    } catch (e) {
      print('❌ Error saving auth data: $e');
    }
  }

  // 🔧 LOGIN WITH FIREBASE AUTHENTICATION
  Future<void> login(
      String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate input
      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email dan password harus diisi');
      }

      // Try Firebase login
      UserCredential userCredential;
      try {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );
      } on FirebaseAuthException catch (e) {
        // If Firebase fails, try offline login
        print('Firebase login failed: $e');
        await _loginOffline(email, password);
        return;
      }

      // Firebase login successful
      final User? user = userCredential.user;
      if (user != null) {
        _userId = user.uid;
        _email = user.email;

        // Extract username from email
        _username = user.email?.split('@').first ?? 'User';

        // Try to load additional user data from Firebase Database
        await _loadUserDataFromFirebase(user.uid);

        // ✅ DITAMBAH: Set userId di ScheduleProvider
        _setScheduleProviderUserId(context, user.uid);

        // Save to SharedPreferences
        _isLoggedIn = true;
        await _saveAuthData();

        print('✅ Login successful: ${user.email}');
      } else {
        throw Exception('Login gagal: User tidak ditemukan');
      }
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔧 SET USER ID DI SCHEDULE PROVIDER
  void _setScheduleProviderUserId(BuildContext context, String userId) {
    try {
      final scheduleProvider =
          Provider.of<ScheduleProvider>(context, listen: false);
      scheduleProvider.setUserId(userId);
      print('✅ Set userId in ScheduleProvider: $userId');
    } catch (e) {
      print('⚠️ Failed to set userId in ScheduleProvider: $e');
    }
  }

  // 🔧 OFFLINE LOGIN (FALLBACK)
  Future<void> _loginOffline(String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users') ?? '[]';
      final List<dynamic> users = json.decode(usersString);

      for (final user in users) {
        if (user['email'] == email && user['password'] == password) {
          // Login successful offline
          _isLoggedIn = true;
          _username = user['username'];
          _email = user['email'];
          _nim = user['nim'] ?? '2201010045';
          _kelas = user['kelas'] ?? 'Teknik Informatika 5C';
          _userId = user['userId'] ??
              'offline_${DateTime.now().millisecondsSinceEpoch}';

          // Save to SharedPreferences
          await _saveAuthData();

          print('✅ Offline login successful: $email');
          return;
        }
      }

      throw Exception('Email atau password salah');
    } catch (e) {
      rethrow;
    }
  }

  // 🔧 LOAD USER DATA FROM FIREBASE DATABASE
  Future<void> _loadUserDataFromFirebase(String userId) async {
    try {
      final DatabaseReference userRef =
          _database.ref().child('users').child(userId);
      final DatabaseEvent event = await userRef.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        final Map<dynamic, dynamic> userData =
            snapshot.value as Map<dynamic, dynamic>;

        _username = userData['username']?.toString() ?? _username;
        _nim = userData['nim']?.toString() ?? _nim ?? '2201010045';
        _kelas =
            userData['kelas']?.toString() ?? _kelas ?? 'Teknik Informatika 5C';

        print('✅ Loaded user data from Firebase');
      } else {
        // Create default user data in Firebase
        await _saveUserDataToFirebase(userId);
      }
    } catch (e) {
      print('⚠️ Failed to load user data from Firebase: $e');
      // Use default values if Firebase fails
      _nim ??= '2201010045';
      _kelas ??= 'Teknik Informatika 5C';
    }
  }

  // 🔧 SAVE USER DATA TO FIREBASE DATABASE
  Future<void> _saveUserDataToFirebase(String userId) async {
    try {
      final DatabaseReference userRef =
          _database.ref().child('users').child(userId);

      await userRef.set({
        'username': _username,
        'email': _email,
        'nim': _nim ?? '2201010045',
        'kelas': _kelas ?? 'Teknik Informatika 5C',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      print('✅ Saved user data to Firebase');
    } catch (e) {
      print('⚠️ Failed to save user data to Firebase: $e');
    }
  }

  // 🔧 REGISTER NEW USER
  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String nim,
    required String kelas,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate input
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        throw Exception('Semua field harus diisi');
      }
      if (password.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }

      // Try Firebase registration
      UserCredential userCredential;
      try {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password.trim(),
        );

        _userId = userCredential.user?.uid;
        _email = email;
        _username = username;
        _nim = nim;
        _kelas = kelas;

        // ✅ DITAMBAH: Set userId di ScheduleProvider
        _setScheduleProviderUserId(context, _userId!);

        // Save user data to Firebase Database
        await _saveUserDataToFirebase(_userId!);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          throw Exception('Email sudah terdaftar');
        }
        throw Exception('Registrasi gagal: ${e.message}');
      } catch (e) {
        // Firebase failed, use offline registration
        print('Firebase registration failed, using offline: $e');
        await _registerOffline(username, email, password, nim, kelas);
        return;
      }

      // Save to SharedPreferences (offline storage)
      await _saveUserToSharedPreferences(
          username, email, password, nim, kelas, _userId!);

      _isLoggedIn = true;
      await _saveAuthData();

      print('✅ Registration successful: $email');
    } catch (e) {
      print('❌ Registration error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔧 OFFLINE REGISTRATION (FALLBACK)
  Future<void> _registerOffline(String username, String email, String password,
      String nim, String kelas) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users') ?? '[]';
      final List<dynamic> users = json.decode(usersString);

      // Check if user already exists
      for (final user in users) {
        if (user['email'] == email) {
          throw Exception('Email sudah terdaftar');
        }
      }

      // Create new user
      final userId = 'offline_${DateTime.now().millisecondsSinceEpoch}';
      final newUser = {
        'userId': userId,
        'username': username,
        'email': email,
        'password': password,
        'nim': nim,
        'kelas': kelas,
        'createdAt': DateTime.now().toIso8601String(),
      };

      users.add(newUser);
      await prefs.setString('users', json.encode(users));

      // Set current user
      _isLoggedIn = true;
      _userId = userId;
      _username = username;
      _email = email;
      _nim = nim;
      _kelas = kelas;

      await _saveAuthData();

      print('✅ Offline registration successful: $email');
    } catch (e) {
      rethrow;
    }
  }

  // 🔧 SAVE USER TO SHARED PREFERENCES
  Future<void> _saveUserToSharedPreferences(String username, String email,
      String password, String nim, String kelas, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users') ?? '[]';
      final List<dynamic> users = json.decode(usersString);

      // Add or update user in list
      int existingIndex = -1;
      for (int i = 0; i < users.length; i++) {
        if (users[i]['userId'] == userId || users[i]['email'] == email) {
          existingIndex = i;
          break;
        }
      }

      final userData = {
        'userId': userId,
        'username': username,
        'email': email,
        'password': password,
        'nim': nim,
        'kelas': kelas,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (existingIndex >= 0) {
        users[existingIndex] = userData;
      } else {
        users.add(userData);
      }

      await prefs.setString('users', json.encode(users));
    } catch (e) {
      print('❌ Error saving user to SharedPreferences: $e');
    }
  }

  // 🔧 UPDATE USER PROFILE
  Future<void> updateProfile({
    String? username,
    String? email,
    String? nim,
    String? kelas,
    String? currentPassword,
    String? newPassword,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Validate current password if changing password
      if (newPassword != null && currentPassword == null) {
        throw Exception('Password saat ini harus diisi');
      }

      // Update Firebase user if online
      try {
        final User? user = _auth.currentUser;

        if (user != null) {
          // Update email if changed
          if (email != null && email != _email) {
            await user.updateEmail(email);
          }

          // Update password if changed
          if (newPassword != null) {
            await user.updatePassword(newPassword);
          }
        }
      } catch (e) {
        print('⚠️ Failed to update Firebase user: $e');
      }

      // Update local state
      if (username != null) _username = username;
      if (email != null) _email = email;
      if (nim != null) _nim = nim;
      if (kelas != null) _kelas = kelas;

      // Update SharedPreferences
      await _saveAuthData();

      // Update user data in Firebase Database
      if (_userId != null && !_userId!.startsWith('offline_')) {
        try {
          final DatabaseReference userRef =
              _database.ref().child('users').child(_userId!);
          await userRef.update({
            if (username != null) 'username': username,
            if (email != null) 'email': email,
            if (nim != null) 'nim': nim,
            if (kelas != null) 'kelas': kelas,
            'updatedAt': DateTime.now().toIso8601String(),
          });
        } catch (e) {
          print('⚠️ Failed to update user in Firebase Database: $e');
        }
      }

      // Update password in SharedPreferences if changed
      if (newPassword != null && _userId != null) {
        await _updatePasswordInSharedPreferences(_userId!, newPassword);
      }

      print('✅ Profile updated successfully');
    } catch (e) {
      print('❌ Profile update error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔧 UPDATE PASSWORD IN SHARED PREFERENCES
  Future<void> _updatePasswordInSharedPreferences(
      String userId, String newPassword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users') ?? '[]';
      final List<dynamic> users = json.decode(usersString);

      for (int i = 0; i < users.length; i++) {
        if (users[i]['userId'] == userId) {
          users[i]['password'] = newPassword;
          users[i]['updatedAt'] = DateTime.now().toIso8601String();
          break;
        }
      }

      await prefs.setString('users', json.encode(users));
    } catch (e) {
      print('❌ Error updating password in SharedPreferences: $e');
    }
  }

  // 🔧 DELETE USER ACCOUNT
  Future<void> deleteAccount(String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Verify password
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users') ?? '[]';
      final List<dynamic> users = json.decode(usersString);

      bool passwordCorrect = false;
      for (final user in users) {
        if ((user['userId'] == _userId || user['email'] == _email) &&
            user['password'] == password) {
          passwordCorrect = true;
          break;
        }
      }

      if (!passwordCorrect) {
        throw Exception('Password salah');
      }

      // Delete from Firebase Auth
      try {
        final User? user = _auth.currentUser;
        if (user != null) {
          await user.delete();
        }
      } catch (e) {
        print('⚠️ Failed to delete from Firebase Auth: $e');
      }

      // Delete from Firebase Database
      if (_userId != null && !_userId!.startsWith('offline_')) {
        try {
          final DatabaseReference userRef =
              _database.ref().child('users').child(_userId!);
          await userRef.remove();
        } catch (e) {
          print('⚠️ Failed to delete from Firebase Database: $e');
        }
      }

      // Delete from SharedPreferences
      final List<dynamic> updatedUsers = [];
      for (final user in users) {
        if (user['userId'] != _userId && user['email'] != _email) {
          updatedUsers.add(user);
        }
      }

      await prefs.setString('users', json.encode(updatedUsers));

      // Clear current user data
      await _clearUserData();

      print('✅ Account deleted successfully');
    } catch (e) {
      print('❌ Account deletion error: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔧 LOGOUT USER
  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Sign out from Firebase
      try {
        await _auth.signOut();
      } catch (e) {
        print('⚠️ Firebase sign out failed: $e');
      }

      // ✅ DITAMBAH: Reset ScheduleProvider data
      _resetScheduleProviderData(context);

      // Clear user data
      await _clearUserData();

      print('✅ Logout successful');
    } catch (e) {
      print('❌ Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔧 RESET SCHEDULE PROVIDER DATA
  void _resetScheduleProviderData(BuildContext context) {
    try {
      final scheduleProvider =
          Provider.of<ScheduleProvider>(context, listen: false);
      scheduleProvider.resetForNewUser();
      print('✅ Reset ScheduleProvider data for new user');
    } catch (e) {
      print('⚠️ Failed to reset ScheduleProvider: $e');
    }
  }

  // 🔧 CLEAR USER DATA
  Future<void> _clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('nim');
      await prefs.remove('kelas');
      await prefs.remove('userId');

      _isLoggedIn = false;
      _username = null;
      _email = null;
      _nim = null;
      _kelas = null;
      _userId = null;
    } catch (e) {
      print('❌ Error clearing user data: $e');
    }
  }

  // 🔧 TOGGLE DARK MODE
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      print('❌ Error saving dark mode preference: $e');
    }

    notifyListeners();
  }

  // 🔧 TOGGLE NOTIFICATIONS
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    } catch (e) {
      print('❌ Error saving notification preference: $e');
    }

    notifyListeners();
  }

  // 🔧 GET ALL USERS (FOR ADMIN FEATURES)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersString = prefs.getString('users') ?? '[]';
      final List<dynamic> users = json.decode(usersString);

      return users.map((user) {
        return {
          'userId': user['userId'],
          'username': user['username'],
          'email': user['email'],
          'nim': user['nim'],
          'kelas': user['kelas'],
          'createdAt': user['createdAt'],
        };
      }).toList();
    } catch (e) {
      print('❌ Error getting all users: $e');
      return [];
    }
  }

  // 🔧 GET CURRENT USER INFO
  Map<String, dynamic> getCurrentUserInfo() {
    return {
      'username': _username,
      'email': _email,
      'nim': _nim,
      'kelas': _kelas,
      'userId': _userId,
      'isLoggedIn': _isLoggedIn,
    };
  }

  // 🔧 CHECK IF USER IS ADMIN (Example - customize as needed)
  Future<bool> isAdmin() async {
    // Example: Check if user email is admin email
    return _email?.endsWith('@admin.com') ?? false;
  }

  // ✅ DITAMBAH: Method untuk mengakses ScheduleProvider tanpa import
  void scheduleProviderSetUserId(BuildContext context, String? userId) {
    try {
      final scheduleProvider =
          Provider.of<ScheduleProvider>(context, listen: false);
      scheduleProvider.setUserId(userId);
    } catch (e) {
      print('⚠️ Failed to set userId in ScheduleProvider: $e');
    }
  }
}
