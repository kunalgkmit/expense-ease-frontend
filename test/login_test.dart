import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_ease_flutter/screens/login_screen.dart';
import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('Login Screen Tests', () {
    testWidgets('Shows error when email is empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: const LoginScreen(),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);

      print('Negative Test Passed: Empty email shows error');
    });

    testWidgets('Accepts valid login credentials', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: const LoginScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'test@gmail.com');
      await tester.enterText(textFields.last, 'password123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter a valid email'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);

      print('Positive Test Passed: Valid credentials accepted');
    });
  });
}
