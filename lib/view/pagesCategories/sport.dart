import 'package:ecomme_app/data/producteHome/PopularProducte.dart';
import 'package:ecomme_app/data/store/datasport/datasport.dart';
import 'package:ecomme_app/view/homePages/home/pages/Container.dart';
import 'package:ecomme_app/view/homePages/store/constant/constBrands.dart';
import 'package:ecomme_app/view/homePages/store/constant/constholdbrandimg.dart';
import 'package:ecomme_app/view/homePages/store/constant/imgconst.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Sport extends StatefulWidget {
  final List<String> imgList = [
    "assets/images/red_shoes1.png",
    "assets/images/red_shoes3.png",
    "assets/images/red_shoes2.png"
  ];
  final List<String> imgList2 = [
    "assets/images/imagesport/ball1.png",
    "assets/images/imagesport/tennis.png",
    "assets/images/imagesport/PingPong_Rackets.png"
  ];
  Sport({super.key});

  @override
  State<Sport> createState() => _SportState();
}

class _SportState extends State<Sport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(23.0),
              child: Column(
                children: [
                  Constholdbrandimg(
                    brands: Constbrands(
                      logo:
                          "https://lottie.host/237e7e05-512d-4511-a10a-0cdc63ad58fc/fPvbIRPjz5.json",
                      name: "Adidas",
                      dess: "a lot of Producte",
                      isborders: false,
                    ),
                    imgBrands: widget.imgList,
                  ),
                  const SizedBox(height: 17),
                  Constholdbrandimg(
                    brands: Constbrands(
                      logo:
                          "https://lottie.host/0fc553d5-1199-4f38-a18b-5f553a47fb7f/5uRILMna46.json",
                      name: "Nike",
                      dess: "more then 100 ",
                      isborders: false,
                    ),
                    imgBrands: widget.imgList2,
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        "You Might Like",
                        style: GoogleFonts.inder(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.only(right:23.0,left: 23.0,bottom: 90,top: 10), 
                
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 30.0,
                childAspectRatio: 0.70,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item3 = ListOfdataSport[index];
                  return Mycontainer2(
                    Price: item3.price,
                    Title: item3.title,
                    Type: item3.type,
                    ImageAasset: item3.img,
                  );
                },
                childCount: ListOfdataSport.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
