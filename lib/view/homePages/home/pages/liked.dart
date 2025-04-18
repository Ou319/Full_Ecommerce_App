import 'package:flutter/material.dart';

class Liked extends StatelessWidget {
  bool isFavorit;
  Liked({required this.isFavorit, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      margin: EdgeInsets.all(10),
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: isFavorit
          ? Icon(
              Icons.favorite,
              color: Colors.red,
            )
          : Icon(Icons.favorite_border),
    );
  }
}
