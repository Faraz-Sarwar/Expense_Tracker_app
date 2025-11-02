import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseRepository {
  final _collection = FirebaseFirestore.instance.collection('Expense');

  Future<void> addExpense(Expense expense) async {
    _collection.add({
      'amount': expense.amount,
      'category': expense.category,
      'date': expense.date,
    });
  }

  Stream<List<Expense>> fetchExpense() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Expense(
          id: doc.id,
          amount: data['amount'],
          category: data['category'],
          date: (data['date'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  //Fetch expenses from Firebase
  Future<List<Map<String, dynamic>>> fetchWeeklyExpenses() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Expense')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  //delete expense
  Future<void> deleteExpense(String id) async {
    _collection.doc(id).delete();
  }

  //get username of the user currently logged in
  Future<String> fetchUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final data = doc.data();
    return data!['username'];
  }
}
