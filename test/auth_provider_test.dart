import 'package:flutter_test/flutter_test.dart';
import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Auth Provider Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('Login stores user data correctly', () async {
      final authProvider = AuthProvider();
      final userData = {
        'id': '123',
        'username': 'Test User',
        'email': 'test@gmail.com',
        'role_id': 'role-123',
        'accessToken': 'token-abc',
        'refreshToken': 'refresh-xyz',
      };

      await authProvider.login(userData);

      expect(authProvider.userId, '123');
      expect(authProvider.username, 'Test User');
      expect(authProvider.email, 'test@gmail.com');
      expect(authProvider.isLoggedIn, true);

      print('Positive Test: Login saves user data');
    });

    test('Logout clears all user data', () async {
      final authProvider = AuthProvider();
      await authProvider.login({
        'id': '123',
        'username': 'Test User',
        'email': 'test@gmail.com',
        'role_id': 'role-123',
        'accessToken': 'token',
        'refreshToken': 'refresh',
      });
      await authProvider.logout();
      expect(authProvider.userId, null);
      expect(authProvider.username, null);
      expect(authProvider.email, null);
      expect(authProvider.isLoggedIn, false);

      print('Positive Test: Logout clears all data');
    });

    test('Correctly identifies user role', () async {
      final authProvider = AuthProvider();

      await authProvider.login({
        'id': '123',
        'username': 'User',
        'email': 'user@gmail.com',
        'role_id': AuthProvider.adminRoleId,
        'accessToken': 'token',
        'refreshToken': 'refresh',
      });

      expect(authProvider.isUser, true);
      expect(authProvider.isAdmin, false);

      print('Positive Test: User role detected correctly');
    });

    test('Handles login with missing data gracefully', () async {
      final authProvider = AuthProvider();

      await authProvider.login({'id': '123'});

      expect(authProvider.userId, '123');
      expect(authProvider.username, null);

      print('Negative Test: Handles incomplete data');
    });
  });
}
