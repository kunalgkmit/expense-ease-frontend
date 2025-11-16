import 'package:expense_ease_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  final num totalBalance;
  final num totalIncome;
  final num totalExpense;

  const BalanceCard({
    Key? key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency(totalBalance),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: totalBalance >= 0
                    ? Colors.green.shade700
                    : Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildIncomeExpenseCard(
                  label: 'INCOME',
                  amount: totalIncome,
                  backgroundColor: Colors.green.shade50,
                  iconColor: Colors.green.shade700,
                  textColor: Colors.green.shade800,
                  icon: Icons.arrow_downward,
                ),
                const SizedBox(width: 16),
                _buildIncomeExpenseCard(
                  label: 'EXPENSE',
                  amount: totalExpense,
                  backgroundColor: Colors.red.shade50,
                  iconColor: Colors.red.shade700,
                  textColor: Colors.red.shade800,
                  icon: Icons.arrow_upward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard({
    required String label,
    required num amount,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: iconColor.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatCurrency(amount),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
