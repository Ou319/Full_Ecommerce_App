import 'package:ecomme_app/view/homePages/home/pages/Container.dart';
import 'package:ecomme_app/view/provider/Buyproductes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Producteselected extends StatefulWidget {
  const Producteselected({super.key});

  @override
  State<Producteselected> createState() => _ProducteselectedState();
}

class _ProducteselectedState extends State<Producteselected> {
  @override
  Widget build(BuildContext context) {
    final classInstancee = Provider.of<Buyproductes>(context);

    List<Mycontainer2> ProducteDeleted = [];

    bool isdelete = false;

    return Scaffold(
        appBar: AppBar(),
        body: classInstancee.ProducteSelected.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.network(
                        "https://lottie.host/f01f0f6a-d3d9-4064-81b7-eb6ab8d193d9/JhkXTXpzTs.json"),
                    SizedBox(height: 20),
                    Text(
                      "The Shop is empty...",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: classInstancee.ProducteSelected.length,
                        itemBuilder: (context, index) {
                          int ProductCount = 0;
                          final fItem = classInstancee.ProducteSelected[index];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.all(10),
                            margin:
                                EdgeInsets.only(right: 15, bottom: 15, top: 15),
                            width: isdelete ? 0 : double.infinity,
                            height: 170,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 238, 238, 238),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.asset(
                                        fItem.ImageAasset,
                                        scale: 40,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                fItem.Type,
                                                style: GoogleFonts.inder(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.verified,
                                                color: Colors.blue,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            fItem.Title,
                                            style: GoogleFonts.inder(
                                              color: Colors.black,
                                              fontSize: 19,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isdelete = !isdelete;
                                          ProducteDeleted.add(fItem);
                                          classInstancee.removeProducte(fItem);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text("producte is remeved"),
                                              action: SnackBarAction(
                                                  label: "Undo",
                                                  onPressed: () {
                                                    classInstancee.addProducte(
                                                        ProducteDeleted.last);
                                                    print(
                                                        "what happing on click on undo");
                                                  }),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 238, 238, 238),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.redAccent,
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    // add or remove producte
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (fItem.count > 0) {
                                                fItem.count--;
                                              }

                                              double calculatedPrice =
                                                  fItem.count * fItem.Price;
                                              if (calculatedPrice == 0) {
                                                classInstancee
                                                    .removeProducte(fItem);

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "producte is remeved"),
                                                    action: SnackBarAction(
                                                        label: "Undo",
                                                        onPressed: () {
                                                          classInstancee
                                                              .addProducte(
                                                                  ProducteDeleted
                                                                      .last);
                                                          print(
                                                              "what happing on click on undo");
                                                        }),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(6),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 238, 238, 238),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(child: Text("-")),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(6),
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 238, 238, 238),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                              child: Text("${fItem.count}")),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              fItem.count++;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(6),
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 49, 132, 248),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                                child: Text(
                                              "+",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // price
                                    Spacer(),
                                    Container(
                                      child: Text(
                                        "\$${fItem.Price * fItem.count}",
                                        style: GoogleFonts.inder(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Text(
                      "Checkout Now ",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    )),
                  )
                ],
              ));
  }
}
