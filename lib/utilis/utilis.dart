import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Utilis {
  static void showCompleteMessage(
    String message,
    Color color,
    IconData icon,
    BuildContext context,
  ) {
    Flushbar(
      message: message,
      backgroundColor: color,
      icon: Icon(icon, color: Colors.white),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
    ).show(context);
  }
}
