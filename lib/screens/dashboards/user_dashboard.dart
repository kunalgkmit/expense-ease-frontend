import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:expense_ease_flutter/screens/login_screen.dart';
import 'package:expense_ease_flutter/widgets/add_transaction_dialog.dart';
import 'package:expense_ease_flutter/widgets/balance_card_widget.dart';
import 'package:expense_ease_flutter/widgets/delete_confirmation_dialog.dart';
import 'package:expense_ease_flutter/widgets/edit_transaction_dialog.dart';
import 'package:expense_ease_flutter/widgets/transaction_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final double _totalBalance = 15000.00;
  final double _totalIncome = 25000.00;
  final double _totalExpense = 10000.00;

  final List<Map<String, dynamic>> _transactions = [
    {'title': 'Salary', 'amount': 50000.0, 'type': 'income'},
    {'title': 'Groceries', 'amount': 2500.0, 'type': 'expense'},
    {'title': 'Rent', 'amount': 15000.0, 'type': 'expense'},
    {'title': 'Freelance Work', 'amount': 8000.0, 'type': 'income'},
    {'title': 'Electricity Bill', 'amount': 1200.0, 'type': 'expense'},
  ];

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddTransactionDialog(),
    );
  }

  void _showEditDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => EditTransactionDialog(
        title: transaction['title'],
        amount: transaction['amount'],
        type: transaction['type'],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        transactionTitle: transaction['title'],
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction deleted!'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${authProvider.username ?? "User"}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 28),
            tooltip: 'Add Transaction',
            onPressed: _showAddTransactionDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(
                totalBalance: _totalBalance,
                totalIncome: _totalIncome,
                totalExpense: _totalExpense,
              ),
              const SizedBox(height: 24),

              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _transactions.length,
                itemBuilder: (context, index) {
                  final transaction = _transactions[index];
                  return TransactionItem(
                    title: transaction['title'],
                    amount: transaction['amount'],
                    type: transaction['type'],
                    onEdit: () => _showEditDialog(transaction),
                    onDelete: () => _showDeleteDialog(transaction),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
