import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';

class Utilis {
  static void showCompleteMessage(String message, Color color, IconData icon) {
    Flushbar(
      message: message,
      backgroundColor: color,
      icon: Icon(icon),
      borderRadius: BorderRadius.circular(8),
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(12),
    );
  }
}
