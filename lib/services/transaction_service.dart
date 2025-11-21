import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TransactionService {
  static String baseUrl = dotenv.env['BASE_URL']??'';

  static Future<Map<String, dynamic>> createTransaction({
    required String userId,
    required String token,
    required String title,
    required double amount,
    required String type,
  }) async {
    try {
      final adjustedAmount = type == 'expense' ? -amount.abs() : amount.abs();

      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'amount': adjustedAmount,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to create transaction'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getSummary({
    required String userId,
    required String token,
  }) async {
    try {
      print('Fetching summary from: $baseUrl/transactions/summary');
      print('User ID: $userId');

      final response = await http.get(
        Uri.parse('$baseUrl/transactions/summary/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Summary response status: ${response.statusCode}');
      print('Summary response body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message':
              'Failed to fetch summary: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('Summary error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> getRecentTransactions({
    required String userId,
    required String token,
    required int page,
  }) async {
    try {
      print('Fetching recent transactions from: $baseUrl/transactions/recent');
      print('User ID: $userId');

      final response = await http.get(
        Uri.parse('$baseUrl/transactions/recent/$userId?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Recent transactions response status: ${response.statusCode}');
      print('Recent transactions response body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message':
              'Failed to fetch transactions: ${response.statusCode} - ${response.body}',
        };
      }
    } catch (e) {
      print('Recent transactions error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> updateTransaction({
    required String transactionId,
    required String userId,
    required String token,
    required String title,
    required double amount,
    required String type,
  }) async {
    try {
      final adjustedAmount = type == 'expense' ? -amount.abs() : amount.abs();

      final response = await http.put(
        Uri.parse('$baseUrl/transactions/$transactionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'title': title,
          'amount': adjustedAmount,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Failed to update transaction'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  static Future<Map<String, dynamic>> deleteTransaction({
    required String transactionId,
    required String userId,
    required String token,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/transactions/$transactionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Transaction deleted successfully'};
      } else {
        return {'success': false, 'message': 'Failed to delete transaction'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }
}
