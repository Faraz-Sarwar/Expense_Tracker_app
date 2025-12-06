class Expense {
  String id;
  double amount;
  String category;
  String currentUserId;
  DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.currentUserId,
    required this.date,
  });
}
