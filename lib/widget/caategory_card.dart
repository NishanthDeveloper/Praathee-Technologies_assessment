import 'package:flutter/material.dart';
class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  CategoryCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}