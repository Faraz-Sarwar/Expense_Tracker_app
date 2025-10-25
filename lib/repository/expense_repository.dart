import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/expense_model.dart';

class ExpenseRepository {
  final _collection = FirebaseFirestore.instance.collection('Expense');

  Future<void> addExpense(Expense expense) async {
    _collection.add({
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date,
    });
  }

  Future<List<Expense>> fetchExpense() async {
    final expenses = await _collection.get();
    return expenses.docs.map((doc) {
      final data = doc.data();
      return Expense(
        id: doc.id,
        amount: data['amount'],
        category: data['category'],
        date: (data['date'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Future<void> deleteExpense(String id) async {
    _collection.doc(id).delete();
  }
}
