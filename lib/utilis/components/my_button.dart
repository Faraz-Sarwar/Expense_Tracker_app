import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const MyButton({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 240,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(child: child),
      ),
    );
  }
}
