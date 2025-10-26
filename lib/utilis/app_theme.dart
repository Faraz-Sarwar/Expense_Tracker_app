import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: 'Poppins',
  primaryColor: const Color(0xFFF5591F),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFFF5591F),
    secondary: const Color(0xFFFF9C00),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(fontSize: 24, color: Colors.white),
    headlineSmall: TextStyle(fontSize: 16, color: Colors.white),
  ),
);
