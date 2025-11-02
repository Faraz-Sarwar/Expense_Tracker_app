import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class Utilis {
  static Future<void> showCompleteMessage(
    String message,
    Color color,
    IconData icon,
    BuildContext context,
  ) async {
    return Flushbar(
      message: message,
      backgroundColor: color,
      icon: Icon(icon, color: Colors.white),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
      duration: Duration(seconds: 2), // Show for 2 seconds
    ).show(context);
  }

  static void changeFocusNode(
    FocusNode current,
    FocusNode next,
    BuildContext context,
  ) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }
}
