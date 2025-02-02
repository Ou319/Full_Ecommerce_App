import 'package:ecomme_app/view/homePages/favorite/favorite.dart';
import 'package:ecomme_app/view/homePages/home/homapage.dart';
import 'package:ecomme_app/view/homePages/profile/profile.dart';
import 'package:ecomme_app/view/homePages/store/store.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Naviagationbottombar extends StatefulWidget {
  const Naviagationbottombar({super.key});

  @override
  State<Naviagationbottombar> createState() => _NaviagationbottombarState();
}

class _NaviagationbottombarState extends State<Naviagationbottombar> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  late final List<Widget> _pages; // Declare the list as late

  @override
  void initState() {
    super.initState();
    // Initialize the _pages list after the object is fully constructed
    _pages = [
      Homapage(pageController: _pageController),
      Store(),
      Favorite(),
      Profile(),
    ];
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Change page when tab is selected
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: _pages,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80,
              padding: EdgeInsets.only(left: 0, right: 0),
              decoration: BoxDecoration(
                  border: Border(
                top: BorderSide(color: Colors.grey, width: 1),
              )),
              child: GNav(
                gap: 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                backgroundColor: Colors.white,
                color: Colors.black54,
                activeColor: Colors.black,
                tabBackgroundColor: Colors.black.withOpacity(0.2),
                selectedIndex: _selectedIndex,
                onTabChange: _onTabSelected,
                tabs: const [
                  GButton(icon: Icons.home_filled, text: "Home"),
                  GButton(icon: Icons.storefront_outlined, text: "Store"),
                  GButton(
                      icon: Icons.favorite_border_outlined, text: "Favorite"),
                  GButton(icon: Icons.person, text: "Profile"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}