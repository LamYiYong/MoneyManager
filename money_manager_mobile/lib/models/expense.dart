class Expense {
  final int id;
  final double amount;
  final String category;
  final String date;
  final String note;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      date: json['date'],
      note: json['note'] ?? '',
    );
  }
}
