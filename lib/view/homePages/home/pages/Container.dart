// import 'package:ecomme_app/view/homePages/home/pages/detailProdute.dart';
// import 'package:ecomme_app/view/homePages/home/pages/liked.dart';
// import 'package:ecomme_app/app/provider/provider_save_data_producte/Buyproductes.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class Mycontainer2 extends StatefulWidget {
//   final String ImageAasset;
//   final String Title;
//   final String Type;
//   final double Price;
//   bool isFavorit;
//   int count;
//   Mycontainer2(
//       {required this.Price,
//       required this.Title,
//       required this.Type,
//       required this.ImageAasset,
//       this.count = 1,
//       this.isFavorit = false,
//       super.key});

//   @override
//   State<Mycontainer2> createState() => _Mycontainer2State();
// }

// class _Mycontainer2State extends State<Mycontainer2> {
  
//   bool isAdd = false;
//   @override
//   Widget build(BuildContext context) {
//     final classInstancee = Provider.of<Buyproductes>(context);
//     return GestureDetector(
//       onTap: (){
//         // TODO:
//       Navigator.push(
//   context, 
//   MaterialPageRoute(
//     builder: (context) => Detailprodute(
//       title: widget.Title,
//       type: widget.Type,
//       Price: widget.Price,
//       imageAsset: widget.ImageAasset,
//       isFavorit: widget.isFavorit,
//       onFavoriteChanged: (bool newValue) {
//         setState(() {
//           widget.isFavorit = newValue;
//         });
//       },
//     )
//   )
// );
//       },
//       child: Container(
//         // color: Colors.blueAccent,
//         decoration: BoxDecoration(
//           // color: Colors.amber,
//           borderRadius: BorderRadius.circular(20),
//           // border: Border.all(width: 1,color: Colors.black)
//         ),
//         child: Column(
//           children: [
//             // SizedBox(he)
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(26, 189, 188, 188),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(20),
//                   bottomRight: Radius.circular(20),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // this is for %
//                       Container(
//                         margin: EdgeInsets.all(10),
//                         width: 60,
//                         height: 30,
//                         decoration: BoxDecoration(
//                           color: Colors.amber,
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: Center(
//                           child: Text("78%"),
//                         ),
//                       ),
//                       // this is for icon hear
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             widget.isFavorit = !widget.isFavorit;
//                           });
//                         },
//                         child: Liked(isFavorit: widget.isFavorit)
//                       )
//                     ],
//                   ),
//                   Expanded(
//                     // width: double.infinity,
//                     // height: 150,
//                     child: Image.asset(
//                       widget.ImageAasset,
//                       // fit: BoxFit.co,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // SizedBox(height: ,)
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // this is the title or name of the product
//                   Text(
//                     widget.Title,
//                     style: GoogleFonts.inder(),
//                   ),
//                   Row(
//                     children: [
//                       // this is the type of the market
//                       Text(
//                         widget.Type,
//                         style: GoogleFonts.inder(fontWeight: FontWeight.w100),
//                       ),
//                       SizedBox(
//                         height: 32,
//                       ),
//                       SizedBox(
//                         width: 3,
//                       ),
//                       Icon(
//                         Icons.verified,
//                         color: Colors.blue,
//                         size: 20,
//                       )
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         "\$ ${widget.Price}",
//                         style: GoogleFonts.inder(fontWeight: FontWeight.bold),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             if (!classInstancee.ProducteSelected.contains(
//                                 widget)) {
//                               classInstancee.addProducte(widget);
//                               isAdd = true;
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text("Item is already added")),
//                               );
//                             }
//                           });
//                         },
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 200),
//                           width: 50,
//                           height: 50,
//                           decoration: BoxDecoration(
//                               color: Colors.blue,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(20),
//                                 bottomRight: Radius.circular(20),
//                               )),
//                           child: Center(
//                             child: isAdd
//                                 ? Text(
//                                     "1",
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.white,
//                                     ),
//                                   )
//                                 : Text(
//                                     "+",
//                                     style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                           ),
//                         ),
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
