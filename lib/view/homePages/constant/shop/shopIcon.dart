import 'package:ecomme_app/view/homePages/ShopFiles/prodectSelected/producteselected.dart';
import 'package:ecomme_app/view/provider/Buyproductes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopIcon extends StatelessWidget {
  final Color color;
  const ShopIcon({required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Buyproductes>(
      builder: (context, buyProductes, child) {
        return AnimatedContainer(
          margin: EdgeInsets.only(right: 10),
          duration: const Duration(milliseconds: 500),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      (context),
                      MaterialPageRoute(
                          builder: (context) => const Producteselected()));
                },
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: color,
                  size: 34,
                ),
              ),
              Positioned(
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      buyProductes.productCount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
