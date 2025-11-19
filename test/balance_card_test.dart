import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_ease_flutter/widgets/balance_card_widget.dart';

void main() {
  group('Balance Card Tests', () {
    testWidgets('Balance card shows all financial data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              totalBalance: 15000.00,
              totalIncome: 25000.00,
              totalExpense: 10000.00,
            ),
          ),
        ),
      );

      expect(find.text('Total Balance'), findsOneWidget);
      expect(find.text('INCOME'), findsOneWidget);
      expect(find.text('EXPENSE'), findsOneWidget);

      print('Positive Test: Balance card displays all data');
    });

    testWidgets('Balance card handles negative balance', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BalanceCard(
              totalBalance: -5000.00,
              totalIncome: 10000.00,
              totalExpense: 15000.00,
            ),
          ),
        ),
      );

      expect(find.text('Total Balance'), findsOneWidget);

      print('Negative Test: Negative balance handled correctly');
    });
  });
}
