import 'package:expense_tracker/utilis/Routes/Routes.dart';
import 'package:expense_tracker/utilis/Routes/route_names.dart';
import 'package:expense_tracker/utilis/app_theme.dart';
import 'package:expense_tracker/view_model/auth_view_model.dart';
import 'package:expense_tracker/view_model/expense_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ViewModel()),
        ChangeNotifierProvider(create: (_) => ExpenseViewModel()), // <-- FIX
      ],
      child: MaterialApp(
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteNames.authWrapper,
        onGenerateRoute: Routes.generateRoutes,
      ),
    );
  }
}
