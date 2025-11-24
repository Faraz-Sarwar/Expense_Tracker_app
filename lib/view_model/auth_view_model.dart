import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:expense_tracker/repository/expense_repository.dart';
import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewModel with ChangeNotifier {
  final _auth = AuthRepository();
  final fetch = ExpenseRepository();
  bool _isloading = false;
  bool get isLoading => _isloading;

  Future<bool> login(String email, String password) async {
    try {
      _isloading = true;
      notifyListeners();
      await _auth.loginUpWithEmailAndPassword(email, password);
      _isloading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }

      _isloading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, String username) async {
    try {
      _isloading = true;
      notifyListeners();
      await _auth.signUpWithEmailAndPassword(email, password, username);
      notifyListeners();
      _isloading = false;
      return true;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      notifyListeners();
      _isloading = false;
      return false;
    }
  }

  Future<String> getUsername() async {
    return await fetch.fetchUsername();
  }

  Future<void> logOut(BuildContext context) async {
    await _auth.signOut(context);
    Navigator.pushReplacementNamed(context, RouteNames.login);
    notifyListeners();
  }

  Stream<double> getTotalAmount() {
    return fetch.getTotal();
  }
}
