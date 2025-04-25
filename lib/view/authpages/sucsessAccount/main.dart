// import 'package:ecomme_app/view/homePages/constant/naviagationBottombar/naviagationBottombar.dart';
// import 'package:ecomme_app/view/homePages/home/homapage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';

// class Main extends StatefulWidget {
//   const Main({super.key});

//   @override
//   State<Main> createState() => _MainState();
// }

// class _MainState extends State<Main> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: Center(
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 500),
//           width: double.infinity,
//           height: double.infinity,
//           margin: EdgeInsets.all(30),
//           child: Column(
//             // crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 300,
//                 height: 300,
//                 child: Lottie.network(
//                     "https://lottie.host/8c312c73-cb6b-4ea2-ac48-07715906a704/Nv4btGdTO1.json"),
//               ),
//               Container(
//                 margin: EdgeInsets.only(right: 20, left: 20),
//                 child: Column(
//                   children: [
//                     Center(
//                       child: Text(
//                         """Your Account Succssefuly 
//               Created""",
//                         style: GoogleFonts.inder(
//                           fontSize: 30,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Center(
//                       child: Text(
//                         """here where u can get anything u want and somthign else 
//     like that you khnow where peaple are very insane""",
//                         style: GoogleFonts.inder(
//                             // fontSize: 20,
//                             ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => Naviagationbottombar()),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: 70,
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Center(
//                       child: Text(
//                     "Continue",
//                     style: GoogleFonts.inder(
//                       color: Colors.white,
//                     ),
//                   )),
//                 ),
//               )
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }
