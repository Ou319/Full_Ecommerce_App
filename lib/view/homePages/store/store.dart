import 'package:ecomme_app/data/store/Brands/brands.dart';
import 'package:ecomme_app/view/homePages/constant/shop/shopIcon.dart';
import 'package:ecomme_app/view/homePages/store/constant/constBrands.dart';
import 'package:ecomme_app/view/pagesCategories/clothes.dart';
import 'package:ecomme_app/view/pagesCategories/elctronic.dart';
import 'package:ecomme_app/view/pagesCategories/firniture.dart';
import 'package:ecomme_app/view/pagesCategories/jacketes.dart';
import 'package:ecomme_app/view/pagesCategories/jawhel.dart';
import 'package:ecomme_app/view/pagesCategories/sport.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';



class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  bool selected = false;
  late final List<Widget> _pages;
  late final List<String> nameCategories = [
    "Sport",
    "Clothes",
    "Elctronic",
    "Furniture",
    "Jawhel",
    "Jackets"
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      Sport(),
      Clothes(),
      Elctronic(),
      Firniture(),
      Jawhel(),
      Jacketes(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bigmargine = 20;
    double padding = 12;
    double smallpadding = 8;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Store",
          style: GoogleFonts.inder(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          ShopIcon(
            color: Colors.black,
          )
        ],
      ),
      body: Column(
        children: [
          // Search container
          Container(
            margin: EdgeInsets.only(
                right: bigmargine, left: bigmargine, top: bigmargine),
            padding: EdgeInsets.all(smallpadding),
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: Colors.grey),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search products",
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  icon: Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
          ),
      
          // Brands section
          Container(
            margin: EdgeInsets.only(
              top: bigmargine,
              right: bigmargine,
              left: bigmargine,
            ),
            width: double.infinity,
            height: 260, // Fixed height for brands section
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Featured Brands",
                      style: GoogleFonts.inder(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: ListOfBrands.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 2.1,
                    ),
                    itemBuilder: (context, index) {
                      final s_item = ListOfBrands[index];
                      return Constbrands(logo: s_item.logo, name: s_item.name, dess: s_item.manyProducts);
                    },
                  ),
                ),
              ],
            ),
          ),
      
          // Categories section
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final t_item = nameCategories[index];
                selected = (_selectedIndex == index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _pageController.jumpToPage(index);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      right: smallpadding,
                      left: smallpadding + 7,
                      top: smallpadding,
                    ),
                    child: Text(
                      t_item,
                      style: GoogleFonts.inder(
                        color: selected ? Colors.blue : Colors.black,
                        fontSize: 18
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      
          Container(
            width: double.infinity,
            height: 2,
            color: const Color.fromARGB(255, 194, 194, 194),
          ),
      
          // Categories PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _pages,
            ),
          ),
        ],
      ),
    );
  }
}