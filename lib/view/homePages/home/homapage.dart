import 'package:ecomme_app/datalist/categories/Popularcategory.dart';
import 'package:ecomme_app/datalist/listContainer/ListoFContainers.dart';
import 'package:ecomme_app/datalist/producteHome/PopularProducte.dart';

import 'package:ecomme_app/view/homePages/constant/shop/shopIcon.dart';
import 'package:ecomme_app/view/homePages/home/pages/Container.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class Homapage extends StatefulWidget {
  final PageController pageController;

  const Homapage({super.key, required this.pageController});

  @override
  State<Homapage> createState() => _HomapageState();
}

class _HomapageState extends State<Homapage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
    void _navigateToStorePage() {
    // Use the PageController to navigate to the Store page (index 1)
   widget.pageController.jumpToPage(1);
  }


  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
      // final parentState = context.findAncestorStateOfType<NaviagationbottombarState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // this is the first container
            Container(
              width: mySize.width,
              height: mySize.height * 0.37,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 1,color: Colors.black),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  
                  ),

              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  // for the appbar
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // this column for the text
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good day for shopping",
                              style: GoogleFonts.inder(
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "OUTMANE EL OUAFA",
                              style: GoogleFonts.inder(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        //icon for the storyboard
                        ShopIcon(color: Colors.black),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // for the search
            
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: mySize.width,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1,color: Colors.black),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Search in Store",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // this is for the Categories
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // the title
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          width: mySize.width,
                          child: Text(
                            "Popular Category ",
                            style: GoogleFonts.inder(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        // the listView
                        SizedBox(
                          height: 140,
                          width: mySize.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ListOfcatigories.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = ListOfcatigories[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _navigateToStorePage();
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 12, right: 12),
                                      padding: EdgeInsets.all(8),
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(width: 1,color:Colors.black),
                                        color: Colors.white,
                                      ),
                                      child: Lottie.network(item.UrlImg),
                                    ),
                                  ),
                                  AnimatedContainer(
                                      duration: Duration(milliseconds: 400),
                                      margin: EdgeInsets.only(right: 6),
                                      child: Text(item.name,
                                          style: GoogleFonts.inder(
                                            color: Colors.black,
                                          ))),
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // this is the second container in the page second part 
        
            Container(
              width: mySize.width,
              height: mySize.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // this is the first container #1
                  Container(
                    margin: EdgeInsets.all(16),
                    width: mySize.width,
                    height: 230,
                    child: PageView.builder(
                        controller: _pageController,
                        itemCount: ListContainers.length,
                        itemBuilder: (context, index) {
                          final item2 = ListContainers[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color:
                                    const Color.fromARGB(255, 234, 234, 234),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(20),
                                        width: 300,
                                        child: Text(
                                          item2.title,
                                          style: GoogleFonts.inder(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(width: 100,),
                                    Container(
                                      width: 200,
                                      height: 200,
                                      child: Image.asset(
                                        item2.img,
                                        // fit: BoxFit.contain,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        onPageChanged: (value) {
                          setState(() {
                            currentIndex = value;
                          });
                        }),
                  ),
            
                  // this is for snack scrool
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < ListContainers.length; i++)
                          Mycontainer(currentIndex == i)
                      ],
                    ),
                  ),
            
                  // this is for The gridView for our producted containers
                  Container(
                    margin: EdgeInsets.only(left: 20,top: 10),
                    child: Text("Popular Products",style: GoogleFonts.inder(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),),
                    alignment: Alignment.topLeft,
                  ),
                  
                  Expanded(
                    // color: const Color.fromARGB(255, 245, 245, 245),
                    // width: mySize.width,
                    // height: mySize.height,
                    // 
                    child: Container(
                      margin: EdgeInsets.all(20),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 
                          crossAxisSpacing: 10.0, // 
                          mainAxisSpacing: 30.0, //
                           childAspectRatio: 0.70,
                        ),
                        itemCount: listOfproducteHome.length,
                        itemBuilder: (context,index){
                          final item3=listOfproducteHome[index];// item of the product in my product list.
                          return Mycontainer2(Price: item3.price, Title: item3.title, Type: item3.type, ImageAasset: item3.img);
                        },
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget Mycontainer(bool isScrolling) {
    return AnimatedContainer(
        margin: EdgeInsets.only(right: 10),
        duration: Duration(milliseconds: 500),
        width: isScrolling ? 47 : 20,
        height: 4,
        decoration: BoxDecoration(
          color: isScrolling ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(7),
        ));
  }
}
