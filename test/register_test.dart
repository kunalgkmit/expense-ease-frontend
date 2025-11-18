import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_ease_flutter/screens/register_screen.dart';
import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('Register Screen Tests', () {
    testWidgets('Shows error when username is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: const RegisterScreen(),
          ),
        ),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Please enter a username'), findsOneWidget);

      print('Negative Test Passed: Empty username shows error');
    });

    testWidgets('Accepts valid registration data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: const RegisterScreen(),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'testuser');
      await tester.enterText(textFields.at(1), 'test@gmail.com');
      await tester.enterText(textFields.at(2), 'password123');

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
      await tester.pump();

      expect(find.text('Please enter a username'), findsNothing);
      expect(find.text('Username must be at least 3 characters'), findsNothing);
      expect(find.text('Please enter your email'), findsNothing);
      expect(find.text('Please enter a valid email'), findsNothing);
      expect(find.text('Please enter your password'), findsNothing);
      expect(find.text('Password must be at least 6 characters'), findsNothing);

      print('Positive Test Passed: Valid registration data accepted');
    });
  });
}
