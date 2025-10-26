import 'package:expense_tracker/utilis/Routes/Routes.dart';
import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/app_theme.dart';
import 'package:expense_tracker/view/home_screen.dart';
import 'package:expense_tracker/view/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: RouteNames.login,
      onGenerateRoute: Routes.generateRoutes,
    );
  }
}
