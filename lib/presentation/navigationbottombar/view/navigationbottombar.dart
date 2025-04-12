import 'package:ecomme_app/presentation/favorite/favoriteview.dart';
import 'package:ecomme_app/presentation/home/home.dart';
import 'package:ecomme_app/presentation/navigationbottombar/viewmodel/navigationbottombarmodel.dart';
import 'package:ecomme_app/presentation/profile/profile.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/valuesmanager.dart';
import 'package:ecomme_app/presentation/store/storeview.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key});

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {

  Navigationbottombarmodel _navigationbottombarmodel = Navigationbottombarmodel(); // this is the view model that hold the logic of this page

  
  void _bind(){
    _navigationbottombarmodel.start(); // this function will start the view model and get the data from it
  }

  @override
  void initState() {
    super.initState();
    _bind();
     
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _navigationbottombarmodel.outputsselctedindex,
      builder: (context,snaphot) {
        return Stack(
          children: [
             PageView(
                onPageChanged: (index) {
                  setState(() {
                    _navigationbottombarmodel.selectedIndex(index);
                  });
                },
                children:_navigationbottombarmodel.pages ,
              ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Appsize.a80,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(color: AppColor.grey, width: 1),
                )),
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  backgroundColor: Colors.white,
                  color: Colors.black54,
                  activeColor: Colors.black,
                  tabBackgroundColor: Colors.black.withOpacity(0.2),
                  selectedIndex: snaphot.data ?? 0,
                  onTabChange: _navigationbottombarmodel.selectedIndex,
                  tabs: const [
                    GButton(icon: Icons.home_filled, text: "Home"),
                    GButton(icon: Icons.storefront_outlined, text: "Store"),
                    GButton(icon: Icons.favorite_border_outlined, text: "Favorite"),
                    GButton(icon: Icons.person, text: "Profile"),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
