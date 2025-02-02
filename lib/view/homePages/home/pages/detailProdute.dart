import 'package:ecomme_app/view/homePages/home/pages/liked.dart';
import 'package:flutter/material.dart';

class Detailprodute extends StatefulWidget {
    final String title;
  final String type;
  final double Price;
  final String imageAsset;
  bool isFavorit;

  Detailprodute({
    required this.title,
    required this.type,
    required this.Price,
    required this.imageAsset,
    bool? isFavorit
    
  }) : isFavorit = (isFavorit == true) ? false : (isFavorit ?? false);

  @override
  State<Detailprodute> createState() => _DetailproduteState();
}

class _DetailproduteState extends State<Detailprodute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        actions: [
          GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isFavorit = !widget.isFavorit;
                          });
                        },
                        child: Liked(isFavorit: widget.isFavorit)
                      )
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         width: double.infinity,
      //         height: 300,
      //         child: Image.asset(widget.imageAsset),
      //       ),
      //       Container(
      //         width: double.infinity,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.only(
      //             topRight: Radius.circular(10),
      //             topLeft: Radius.circular(10),
      //           )
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}