import 'package:ecomme_app/app/provider/Buyproductes.dart';
import 'package:ecomme_app/domain/model/modeles.dart';
import 'package:ecomme_app/presentation/cartShop/cartshop.dart';
import 'package:ecomme_app/view/homePages/home/pages/liked.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    final cartProvider = Provider.of<Buyproductes>(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(widget.imageAsset),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
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
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.isFavorit = !widget.isFavorit;
                          });
                        },
                        child: Liked(isFavorit: widget.isFavorit),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    widget.title,
                    style: GoogleFonts.inder(),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.type,
                        style: GoogleFonts.inder(fontWeight: FontWeight.w100),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$ ${widget.price}",
                        style: GoogleFonts.inder(fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          try {
                            // Create a ProducteModel correctly
                            final product = ProducteModel(
                              Price: widget.price,
                              Title: widget.title,
                              description: "", // You can pass real description if you have
                              category: widget.type, // Passing type as category
                              ImageAasset: widget.imageAsset,
                              count: widget.count,
                              isFavorit: widget.isFavorit,
                            );

                            // Check if already exists
                            final exists = cartProvider.ProducteSelected
                                .any((item) => item.Title == product.Title);

                            if (!exists) {
                              cartProvider.addProduct(product);
                              setState(() {
                                isAdd = true;
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CartShop(),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Item is already added")),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.toString()}")),
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
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
            ),
          ],
        ),
      ),
    );
  }
}
