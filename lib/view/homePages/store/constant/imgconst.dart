import 'package:flutter/material.dart';

class Imgconst extends StatelessWidget {
  final String img;
  const Imgconst({required this.img ,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 15,top: 15),
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),  
      ),
      child: Image.asset(img),
    );
  }
}