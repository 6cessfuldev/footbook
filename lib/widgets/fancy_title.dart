import 'package:flutter/material.dart';

class FancyTitle extends StatelessWidget {
  final String title;

  const FancyTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.blue[700],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
