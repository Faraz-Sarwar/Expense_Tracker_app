import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/view/add_expense.dart';
import 'package:expense_tracker/view/all_expenses.dart';
import 'package:expense_tracker/view/forgot_password.dart';
import 'package:expense_tracker/view_model/auth_wrapper.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:expense_tracker/view/login_screen.dart';
import 'package:expense_tracker/view/sign_up_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RouteNames.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case RouteNames.signUp:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case RouteNames.addExpense:
        return MaterialPageRoute(builder: (context) => const AddExpense());
      case RouteNames.allExpense:
        return MaterialPageRoute(builder: (context) => AllExpenses());
      case RouteNames.authWrapper:
        return MaterialPageRoute(builder: (context) => AuthWrapper());
      case RouteNames.forgotPassword:
        return MaterialPageRoute(builder: (context) => ForgotPasswordScreen());
      default:
        // Always return something, even if route not found
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('No route defined for this name')),
          ),
        );
    }
  }
}
