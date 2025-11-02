import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _collection = FirebaseFirestore.instance.collection('users');

  Future<UserCredential> loginUpWithEmailAndPassword(
    String email,
    String pass,
  ) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: pass);
  }

  Future<UserCredential> signUpWithEmailAndPassword(
    String email,
    String pass,
    String username,
  ) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: pass,
    );
    await userCredential.user!.updateDisplayName(username);
    try {
      await _collection.doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
      });
      print('document added');
    } catch (e) {
      print(e.toString());
    }
    return userCredential;
  }

  Future<void> signOut(BuildContext context) async {
    _auth.signOut();
  }
}
