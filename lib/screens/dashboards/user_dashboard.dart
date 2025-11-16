import 'dart:developer';

import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:expense_ease_flutter/screens/login_screen.dart';
import 'package:expense_ease_flutter/services/transaction_service.dart';
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
  bool _isLoading = true;
  num _totalBalance = 0;
  num _totalIncome = 0;
  num _totalExpense = 0;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([_loadSummary(), _loadRecentTransactions()]);
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadSummary() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId ?? '';
      final token = authProvider.accessToken ?? '';

      print('Loading summary for userId: $userId');

      final result = await TransactionService.getSummary(
        userId: userId,
        token: token,
      );

      print('Summary result: $result');

      if (!mounted) return;

      if (result['success']) {
        final data = result['data'];
        setState(() {
          _totalBalance = data['totalBalance'] ?? 0;
          _totalIncome = data['totalIncome'] ?? 0;
          // Backend returns negative expense, convert to positive for display
          _totalExpense = (data['totalExpense'] ?? 0).abs();
        });
      } else {
        print('Failed to load summary: ${result['message']}');
      }
    } catch (e) {
      print('Error loading summary: $e');
    }
  }

  Future<void> _loadRecentTransactions() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId ?? '';
      final token = authProvider.accessToken ?? '';

      print('Loading recent transactions for userId: $userId');

      final result = await TransactionService.getRecentTransactions(
        userId: userId,
        token: token,
      );

      print('Recent transactions result: $result');

      if (!mounted) return;

      if (result['success']) {
        final List<dynamic> transactions = result['data'];
        setState(() {
          _transactions = transactions.map((t) {
            return {
              'id': t['id'] ?? '',
              'title': t['title'] ?? '',
              'amount': double.tryParse(t['amount'] ?? 0) ?? 0,
            };
          }).toList();
        });
        print('Loaded ${_transactions.length} transactions');
      } else {
        print('Failed to load transactions: ${result['message']}');
      }
    } catch (e) {
      print('Error loading transactions: $e');
    }
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTransactionDialog(onSuccess: _loadAllData),
    );
  }

  void _showEditDialog(Map<String, dynamic> transaction) {
    final num amount = transaction['amount'];
    final type = amount > 0 ? 'income' : 'expense';

    showDialog(
      context: context,
      builder: (context) => EditTransactionDialog(
        transactionId: transaction['id'],
        title: transaction['title'],
        amount: amount,
        type: type,
        onSuccess: _loadAllData,
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        transactionId: transaction['id'],
        transactionTitle: transaction['title'],
        onSuccess: _loadAllData,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAllData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance Card Widget
                      BalanceCard(
                        totalBalance: _totalBalance,
                        totalIncome: _totalIncome,
                        totalExpense: _totalExpense,
                      ),
                      const SizedBox(height: 24),

                      // Recent Transactions Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Transactions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: _loadAllData,
                            tooltip: 'Refresh',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Transactions List
                      _transactions.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.receipt_long_outlined,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No transactions yet',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton.icon(
                                      onPressed: _showAddTransactionDialog,
                                      icon: const Icon(Icons.add),
                                      label: const Text(
                                        'Add your first transaction',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = _transactions[index];
                                return TransactionItem(
                                  id: transaction['id'],
                                  title: transaction['title'],
                                  amount: transaction['amount'],
                                  onEdit: () => _showEditDialog(transaction),
                                  onDelete: () =>
                                      _showDeleteDialog(transaction),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
