import 'package:expense_tracker/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel with ChangeNotifier {
  final _auth = AuthRepository();
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

  Future<bool> signUp(String email, String password) async {
    try {
      _isloading = true;
      notifyListeners();
      await _auth.signUpWithEmailAndPassword(email, password);
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
}
