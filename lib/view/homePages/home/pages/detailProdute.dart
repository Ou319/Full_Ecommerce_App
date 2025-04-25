// import 'package:ecomme_app/view/homePages/home/pages/Container.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:ecomme_app/view/homePages/home/pages/liked.dart';
// import 'package:ecomme_app/app/provider/provider_save_data_producte/Buyproductes.dart';
// import 'package:share_plus/share_plus.dart';

// class Detailprodute extends StatefulWidget {
//   final String title;
//   final String type;
//   final double Price;
//   final String imageAsset;
//   bool isFavorit;
//   int count;
//   final Function(bool) onFavoriteChanged;

//   Detailprodute({
//     required this.title,
//     required this.type,
//     required this.Price,
//     required this.imageAsset,
//     required this.isFavorit,
//     required this.onFavoriteChanged,
//     this.count = 1,
//   });

//   @override
//   State<Detailprodute> createState() => _DetailproduteState();
// }

// class _DetailproduteState extends State<Detailprodute>
//     with SingleTickerProviderStateMixin {
//   bool iScolor = false;
//   bool isAdd = false;
//   String selectedSize = "L";
//   Color selectedColor = Colors.red;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.5),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutQuart,
//     ));

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final classInstancee = Provider.of<Buyproductes>(context);

//     // Create a Mycontainer2 instance to match the expected type
//     final productToAdd = Mycontainer2(
//       Title: widget.title,
//       Type: widget.type,
//       Price: widget.Price,
//       ImageAasset: widget.imageAsset,
//       isFavorit: widget.isFavorit,
//       count: widget.count,
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         actions: [
//           GestureDetector(
//               onTap: () {
//                 setState(() {
//                   widget.isFavorit = !widget.isFavorit;
//                   widget.onFavoriteChanged(widget.isFavorit);
//                 });
//               },
//               child: Liked(isFavorit: widget.isFavorit))
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FadeTransition(
//               opacity: _fadeAnimation,
//               child: Container(
//                 width: double.infinity,
//                 height: 300,
//                 color: Colors.white,
//                 child: Hero(
//                   tag: widget.imageAsset,
//                   child: Image.asset(
//                     widget.imageAsset,
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//             ),
//             SlideTransition(
//               position: _slideAnimation,
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Container(
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(20),
//                         topLeft: Radius.circular(20),
//                       )),
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {},
//                             child: Container(
//                               width: 160,
//                               height: 50,
//                               child: Lottie.network(
//                                   "https://lottie.host/838cb9aa-8db0-44de-88e5-438bf028e3fd/8X7hwIiS5A.json"),
//                             ),
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text("5.0 (199)"),
//                           Spacer(),
//                           GestureDetector(
//                             onTap: () {
//                               String shareText =
//                                   "Check out this product: ${widget.title} \nPrice: ${widget.Price} MAD \nLink: https://example.com/product/${widget.title.replaceAll(' ', '_')}";

//                               Share.share(shareText).then((_) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text("Product shared successfully!"),
//                                     duration: Duration(seconds: 2),
//                                     backgroundColor: Colors.green,
//                                   ),
//                                 );
//                               }).catchError((error) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text("Failed to share product."),
//                                     duration: Duration(seconds: 2),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               });
//                             },
//                             child: Container(
//                               width: 50,
//                               height: 50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(2),
//                                 child: Lottie.network(
//                                     "https://lottie.host/d003401e-01bc-41ca-b193-44868b7ce342/NnABIpMGNb.json"),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         widget.title,
//                         style: GoogleFonts.inder(
//                             fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 "Stoke:",
//                                 style: GoogleFonts.inder(
//                                     color: Colors.black, fontSize: 16),
//                               ),
//                               Text(
//                                 " in Stock",
//                                 style: GoogleFonts.inder(
//                                     color: const Color.fromARGB(255, 0, 0, 0),
//                                     fontSize: 18),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 widget.type,
//                                 style: GoogleFonts.inder(
//                                     color: Colors.grey[600], fontSize: 16),
//                               ),
//                             ],
//                           ),
//                           SizedBox(width: 4),
//                           Icon(Icons.verified, color: Colors.blue, size: 20)
//                         ],
//                       ),
//                       SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "\$${widget.Price}",
//                             style: GoogleFonts.inder(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Text(
//                                       "Quantity: ",
//                                       style: GoogleFonts.inder(
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                     Text(
//                                       "${widget.count}",
//                                       style: GoogleFonts.inder(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SlideTransition(
//               position: _slideAnimation,
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Container(
//                   margin: EdgeInsets.all(10),
//                   width: double.infinity,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Color",
//                         style: GoogleFonts.inder(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         children: [Colors.red, Colors.green, Colors.orange]
//                             .map((color) {
//                           return Container(
//                               margin: EdgeInsets.all(3),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedColor = color;
//                                   });
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: Duration(milliseconds: 300),
//                                   width: 50,
//                                   height: 50,
//                                   decoration: BoxDecoration(
//                                       color: color,
//                                       shape: BoxShape.circle,
//                                       border: Border.all(
//                                           width: selectedColor == color ? 2 : 1,
//                                           color: selectedColor == color
//                                               ? Colors.black
//                                               : Colors.transparent)),
//                                 ),
//                               ));
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SlideTransition(
//               position: _slideAnimation,
//               child: FadeTransition(
//                 opacity: _fadeAnimation,
//                 child: Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Size",
//                         style: GoogleFonts.inder(
//                           color: Colors.black,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         textAlign: TextAlign.start,
//                       ),
//                       SizedBox(
//                         height: 7,
//                       ),
//                       Row(
//                         children: ["L", "XL", "XXL"].map((size) {
//                           return GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 selectedSize = size;
//                               });
//                             },
//                             child: AnimatedContainer(
//                               duration: Duration(milliseconds: 300),
//                               margin: EdgeInsets.only(right: 10),
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: selectedSize == size ? 2 : 1,
//                                   color: selectedSize == size
//                                       ? Colors.blue
//                                       : const Color.fromARGB(255, 26, 26, 26),
//                                 ),
//                                 borderRadius: BorderRadius.circular(6),
//                                 color: Colors.transparent,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color.fromARGB(255, 255, 255, 255)
//                                         .withOpacity(0.1),
//                                     spreadRadius: 1,
//                                     blurRadius: 4,
//                                     offset: Offset(1, 1),
//                                   ),
//                                 ],
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   size,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (!classInstancee.ProducteSelected.contains(productToAdd)) {
//                     classInstancee.addProducte(productToAdd);
//                     isAdd = true;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Product added to cart successfully!"),
//                         backgroundColor: Colors.green,
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text("Item is already in cart"),
//                         backgroundColor: Colors.orange,
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                   }
//                 });
//               },
//               child: Container(
//                 margin: EdgeInsets.all(10),
//                 padding: EdgeInsets.all(10),
//                 width: double.infinity,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: isAdd ? Colors.grey : Colors.blue,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     isAdd ? "Added to Cart" : "Add to Cart",
//                     style: TextStyle(
//                       fontSize: 19,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }