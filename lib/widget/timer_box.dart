import 'package:flutter/material.dart';
class TimerBox extends StatelessWidget {
  final String label;
  final String subtitle;

  TimerBox({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(subtitle, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}