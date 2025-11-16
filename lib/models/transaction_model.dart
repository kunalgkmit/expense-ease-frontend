class Transaction {
  final String id;
  final String userId;
  final String title;
  final double amount;
  final String type;
  final String? category;
  final String? description;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.title,
    required this.amount,
    required this.type,
    this.category,
    this.description,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['user_id'] ?? json['userId'] ?? '',
      title: json['title'] ?? '',
      amount: double.tryParse(json['amount'] ?? 0) ?? 0,
      type: json['type'] ?? 'expense',
      category: json['category'],
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
