import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_ease_flutter/widgets/add_transaction_dialog.dart';
import 'package:expense_ease_flutter/widgets/edit_transaction_dialog.dart';
import 'package:expense_ease_flutter/widgets/delete_confirmation_dialog.dart';
import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  group('Transaction Tests', () {
    testWidgets('Add transaction shows error when title is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: Scaffold(
              body: Builder(
                builder: (context) => AddTransactionDialog(onSuccess: () {}),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Please fill all fields'), findsOneWidget);

      print('Negative Test: Empty title validation works');
    });

    testWidgets('Add transaction accepts valid data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: Scaffold(
              body: Builder(
                builder: (context) => AddTransactionDialog(onSuccess: () {}),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Salary');
      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '50000');

      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('50000'), findsOneWidget);

      print('Positive Test: Valid transaction data accepted');
    });
    testWidgets('Edit transaction dialog displays existing data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => AuthProvider(),
            child: Scaffold(
              body: EditTransactionDialog(
                transactionId: '123',
                title: 'Groceries',
                amount: 2500.0,
                type: 'expense',
                onSuccess: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('2500.0'), findsOneWidget);

      print('Positive Test: Edit dialog shows existing data');
    });

    testWidgets('Delete confirmation shows transaction title', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChangeNotifierProvider(
              create: (_) => AuthProvider(),
              child: DeleteConfirmationDialog(
                transactionId: '123',
                transactionTitle: 'Monthly Rent',
                onSuccess: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Delete Transaction'), findsOneWidget);
      expect(find.textContaining('Monthly Rent'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      print('Positive Test: Delete confirmation displays correctly');
    });
  });
}
