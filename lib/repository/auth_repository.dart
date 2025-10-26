import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> loginUpWithEmailAndPassword(
    String email,
    String pass,
  ) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String pass,
  ) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
  }
}
