import 'package:expense_tracker/view/buttom_navigation.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:expense_tracker/view/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (snapshot.hasData) {
          return const ButtomNavigation();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
