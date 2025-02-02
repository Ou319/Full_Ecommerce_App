import 'package:ecomme_app/view/homePages/store/constant/constBrands.dart';
import 'package:ecomme_app/view/homePages/store/constant/imgconst.dart';
import 'package:flutter/material.dart';

class Constholdbrandimg extends StatelessWidget {
  final Widget brands;
  final List<String> imgBrands; 

  const Constholdbrandimg({
    required this.brands,
    required this.imgBrands, 
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          brands,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: imgBrands
                .map((img) => Imgconst(img: img)) 
                .toList(),
          ),
        ],
      ),
    );
  }
}
