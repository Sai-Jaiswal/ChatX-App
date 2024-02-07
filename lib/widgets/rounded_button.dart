import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final double size;
  final Function() buttonFunc;
  const RoundedButton({super.key, required this.title, required this.size, required this.buttonFunc});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonFunc,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: size
          ),
        ),
      )
    );
  }
}
