import 'package:ecomme_app/app/provider/Likedproducte.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../domain/model/modeles.dart';
import '../../app/provider/Buyproductes.dart';
import '../cartShop/cartshop.dart';

class Shapeproducte extends StatefulWidget {
  final String imageAsset;
  final String title;
  final String type;
  final double price;
  final double rating;
  bool isFavorit;
  int count;

  Shapeproducte({
    required this.price,
    required this.title,
    required this.type,
    required this.imageAsset,
    required this.rating,
    this.count = 1,
    this.isFavorit = false,
    super.key,
  });

  @override
  State<Shapeproducte> createState() => _ShapeproducteState();
}

class _ShapeproducteState extends State<Shapeproducte> {
  
  bool isAdd = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Buyproductes>(context); // and this one is for producte in cart shop
    final likedProvider = Provider.of<LikedProductes>(context);// this for get shared prefences 
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج + التقييم والقلب في الأعلى
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(widget.imageAsset),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          widget.rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isFavorit = !widget.isFavorit;
                          final product = ProducteModel(
                          Price: widget.price,
                          Title: widget.title,
                          rating: widget.rating,
                          description: "",
                          category: widget.type,
                          ImageAasset: widget.imageAsset,
                          count: widget.count,
                          isFavorit: widget.isFavorit,
                        );

                        likedProvider.toggleLike(product);
                      });
                    },
                    child: Icon(
                      widget.isFavorit ? Icons.favorite : Icons.favorite_border,
                      color: widget.isFavorit ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.inder(),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      widget.type,
                      style: GoogleFonts.inder(fontWeight: FontWeight.w100),
                    ),
                    const SizedBox(width: 3),
                    const Icon(Icons.verified, color: Colors.blue, size: 18),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$ ${widget.price.toStringAsFixed(2)}",
                      style: GoogleFonts.inder(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        final product = ProducteModel(
                          Price: widget.price,
                          rating: widget.rating,
                          Title: widget.title,
                          description: "",
                          category: widget.type,
                          ImageAasset: widget.imageAsset,
                          count: widget.count,
                          isFavorit: widget.isFavorit,
                        );

                        final exists = cartProvider.ProducteSelected
                            .any((item) => item.Title == product.Title);

                        if (!exists) {
                          cartProvider.addProduct(product);
                          setState(() => isAdd = true);

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartShop()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Item is already added")),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isAdd ? "✓" : "+",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
