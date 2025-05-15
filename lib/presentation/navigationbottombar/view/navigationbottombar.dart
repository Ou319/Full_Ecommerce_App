import 'package:ecomme_app/presentation/favorite/favoriteview.dart';
import 'package:ecomme_app/presentation/navigationbottombar/viewmodel/navigationbottombarmodel.dart';
import 'package:ecomme_app/presentation/profile/profile.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/valuesmanager.dart';
import 'package:ecomme_app/presentation/store/view/storeview.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key});

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  final Navigationbottombarmodel _navigationbottombarmodel = Navigationbottombarmodel();

  void _bind() {
    _navigationbottombarmodel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  void dispose() {
    _navigationbottombarmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _navigationbottombarmodel.outputsselctedindex,
      builder: (context, snapshot) {
        final currentIndex = snapshot.data ?? 0;

        return Stack(
          children: [
            PageView(
              controller: _navigationbottombarmodel.pageController,
              onPageChanged: (index) {
                _navigationbottombarmodel.selectedIndex(index);
              },
              children: _navigationbottombarmodel.pages,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: Appsize.a80,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                  border: Border(
                    top: BorderSide(color: AppColor.grey, width: 1),
                  ),
                ),
                
                child: GNav(
                  gap: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  backgroundColor: Colors.white,
                  color: const Color.fromARGB(137, 35, 28, 28),
                  activeColor: Colors.black,
                  tabBackgroundColor: Colors.black.withOpacity(0.2),
                  selectedIndex: currentIndex,
                  onTabChange: (index) {
                    _navigationbottombarmodel.pageController.jumpToPage(index);
                    _navigationbottombarmodel.selectedIndex(index);
                  },
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
      },
    );
  }
}
