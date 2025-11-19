import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _username;
  String? _email;
  String? _roleId;
  String? _accessToken;
  String? _refreshToken;
  bool _isLoggedIn = false;

  String? get userId => _userId;
  String? get username => _username;
  String? get email => _email;
  String? get roleId => _roleId;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  bool get isLoggedIn => _isLoggedIn;

  static const String adminRoleId = 'b9e0e7b5-4f4b-4e54-9a02-7f5f112b9af8';

  bool get isAdmin => _roleId != adminRoleId;
  bool get isUser => _roleId == adminRoleId;

  Future<void> login(Map<String, dynamic> userData) async {
    _userId = userData['id'];
    _username = userData['username'];
    _email = userData['email'];
    _roleId = userData['role_id'];
    _accessToken = userData['accessToken'];
    _refreshToken = userData['refreshToken'];
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', _userId ?? '');
    await prefs.setString('username', _username ?? '');
    await prefs.setString('email', _email ?? '');
    await prefs.setString('roleId', _roleId ?? '');
    await prefs.setString('accessToken', _accessToken ?? '');
    await prefs.setString('refreshToken', _refreshToken ?? '');
    await prefs.setBool('isLoggedIn', true);

    notifyListeners();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _username = prefs.getString('username');
    _email = prefs.getString('email');
    _roleId = prefs.getString('roleId');
    _accessToken = prefs.getString('accessToken');
    _refreshToken = prefs.getString('refreshToken');
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    notifyListeners();
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      if (_refreshToken != null && _refreshToken!.isNotEmpty) {
        try {
          final response = await http.post(
            Uri.parse('http://10.239.255.1:8000/api/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Cookie': 'refreshToken=$_refreshToken',
            },
          );

          print('Logout API response: ${response.statusCode}');
        } catch (apiError) {
          print('Logout API error: $apiError');
        }
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _userId = null;
      _username = null;
      _email = null;
      _roleId = null;
      _accessToken = null;
      _refreshToken = null;
      _isLoggedIn = false;

      notifyListeners();

      return {'success': true, 'message': 'Logout successful'};
    } catch (e) {
      print('Logout error: $e');
      return {'success': false, 'message': 'Logout error: ${e.toString()}'};
    }
  }
}
