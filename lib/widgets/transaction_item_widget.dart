import 'package:expense_ease_flutter/utils/utils.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String id;
  final String title;
  final num amount;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TransactionItem({
    Key? key,
    required this.id,
    required this.title,
    required this.amount,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    final displayAmount = amount.abs();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isIncome
              ? Colors.green.shade100
              : Colors.red.shade100,
          child: Icon(
            isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        subtitle: Text(
          isIncome ? 'Income' : 'Expense',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              formatCurrency(displayAmount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isIncome ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                } else if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
