import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/model/expense_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpenseRepository {
  final _collection = FirebaseFirestore.instance.collection('Expense');

  Future<void> addExpense(Expense expense) async {
    _collection.add({
      'id': expense.id,
      'amount': expense.amount,
      'category': expense.category,
      'date': Timestamp.fromDate(expense.date),
      "currentUserId": expense.currentUserId,
    });
  }

  Stream<List<Expense>> fetchExpense() {
    // Get start of current week (Monday)s
    final now = DateTime.now();

    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekMidnight = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return _collection
        .where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeekMidnight),
        )
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return Expense(
              id: doc.id,
              amount: (data['amount'] as num).toDouble(),
              category: data['category'],
              date: (data['date'] as Timestamp).toDate(),
              currentUserId: FirebaseAuth.instance.currentUser!.uid,
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
    try {
      User? user;
      while (user == null) {
        user = FirebaseAuth.instance.currentUser;
        await Future.delayed(const Duration(milliseconds: 500));
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      return data?['username'] ?? "User";
    } catch (e) {
      throw "Error $e occured";
    }
  }

  Stream<double> getTotal() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekMidnight = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );

    return _collection
        .where(
          'date',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeekMidnight),
        )
        .where(
          'currentUserId',
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .snapshots()
        .map((snapshot) {
          double total = 0;
          for (var doc in snapshot.docs) {
            final data = doc.data();
            total += (data['amount'] as num).toDouble();
          }
          return total;
        });
  }

  Future<int?> getDocCount() async {
    final result = await _collection.count().get();
    return result.count;
  }
}
