import 'package:flutter/material.dart';
import 'package:praathee_technologies_assessment/screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-commerce UI',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: EcommerceLandingPage(),
    );
  }
}


