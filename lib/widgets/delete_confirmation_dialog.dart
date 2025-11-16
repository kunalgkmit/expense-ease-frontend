import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String transactionTitle;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.transactionTitle,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Transaction'),
      content: Text('Are you sure you want to delete "$transactionTitle"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
