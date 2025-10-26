import 'package:expense_tracker/model/expense_model.dart';
import 'package:expense_tracker/repository/expense_repository.dart';
import 'package:flutter/material.dart';

class ExpenseViewModel with ChangeNotifier {
  final repo = ExpenseRepository();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> addExpense(Expense expense) async {
    try {
      _isLoading = true;
      await repo.addExpense(expense);
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
      await repo.deleteExpense(id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<List<Expense>> getExpense() async {
    return repo.fetchExpense();
  }
}
