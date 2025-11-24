import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/repository/expense_repository.dart';
import 'package:flutter/material.dart';

class ExpenseViewModel with ChangeNotifier {
  ExpenseRepository repository = ExpenseRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> addExpense(Expense expense) async {
    try {
      _isLoading = true;
      await repository.addExpense(expense);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteExpense(String id) async {
    try {
      _isLoading = true;
      await repository.deleteExpense(id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Stream<List<Expense>> getExpense() {
    return repository.fetchExpense();
  }
}
