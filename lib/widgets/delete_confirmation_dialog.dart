import 'package:expense_ease_flutter/providers/auth_provider.dart';
import 'package:expense_ease_flutter/services/transaction_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationDialog extends StatefulWidget {
  final String transactionId;
  final String transactionTitle;
  final VoidCallback onSuccess;

  const DeleteConfirmationDialog({
    Key? key,
    required this.transactionId,
    required this.transactionTitle,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<DeleteConfirmationDialog> createState() =>
      _DeleteConfirmationDialogState();
}

class _DeleteConfirmationDialogState extends State<DeleteConfirmationDialog> {
  bool _isLoading = false;

  Future<void> _handleDelete() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.userId ?? '';
    final token = authProvider.accessToken ?? '';

    final result = await TransactionService.deleteTransaction(
      transactionId: widget.transactionId,
      userId: userId,
      token: token,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Transaction deleted successfully!'),
          backgroundColor: Colors.red,
        ),
      );
      widget.onSuccess();
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed to delete transaction'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Transaction'),
      content: Text(
        'Are you sure you want to delete "${widget.transactionTitle}"?',
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleDelete,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
