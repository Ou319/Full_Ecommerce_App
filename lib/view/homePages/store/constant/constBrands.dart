import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Constbrands extends StatelessWidget {
  final String logo;
  final String name;
  final String dess;
  final bool isborders;
  // Constructor to accept logo, name, and description
  const Constbrands({
    super.key,
    required this.logo,
    required this.name,
    required this.dess,
    this.isborders=true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: EdgeInsets.only(
        top: 20,
         left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        border:isborders? Border.all(width: 1, color: Colors.grey):Border.all(width: 0,color: Colors.transparent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Lottie.network(logo),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: GoogleFonts.inder(
                      fontWeight: FontWeight.bold,
                    ),

                  ),
                  SizedBox(width: 3,),
                  
                  Icon(Icons.verified,color: Colors.blue,size: 14,)
                ],
              ),
              Text(
                dess,
                style: GoogleFonts.inder(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
