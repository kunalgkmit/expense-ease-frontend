import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminService {
  static const String baseUrl = 'http://54.227.16.96:8000/api';

  static Future<Map<String, dynamic>> getAllUsers(String token) async {
    try {
      print('Fetching users from: $baseUrl/admin/users');

      final response = await http.get(
        Uri.parse('$baseUrl/admin/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Users response status: ${response.statusCode}');
      print('Users response body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch users: ${response.statusCode}',
        };
      }
    } catch (e) {
      print('Get users error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
