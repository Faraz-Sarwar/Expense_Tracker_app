enum Category { shopping, food, grocery }

class Expense {
  String id;
  double amount;
  Category category;
  DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
  });
}
