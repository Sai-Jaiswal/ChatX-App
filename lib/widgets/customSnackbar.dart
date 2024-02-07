import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final content;
  const CustomSnackBar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(content),
      backgroundColor: Colors.purple,
      shape: RoundedRectangleBorder(),
      duration: Duration(seconds: 1),
    );
  }
}
