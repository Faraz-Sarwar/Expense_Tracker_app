enum Category { shopping, food, grocery }

class Expense {
  double amount;
  Category category;
  DateTime date;

  Expense({required this.amount, required this.category, required this.date});

  // Convert to JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category.name,
      'date': date.toIso8601String(),
    };
  }

  //Convert from JSON
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      amount: json['amount'],
      category: Category.values.firstWhere((e) => e.name == json['category']),
      date: DateTime.parse(json['date']),
    );
  }
}
