import 'package:ecomme_app/presentation/admindashbord/screens/ProductManagementPage.dart';
import 'package:ecomme_app/presentation/admindashbord/screens/ProfileAdminPage.dart';
import 'package:ecomme_app/presentation/admindashbord/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


class Navigationbottombaradmin extends StatefulWidget {
  const Navigationbottombaradmin({super.key});

  @override
  State<Navigationbottombaradmin> createState() => _NavigationbottombaradminState();
}

class _NavigationbottombaradminState extends State<Navigationbottombaradmin> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomepageAdmin(),
    Productmanagementpage(),
    Profileadminpage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: GNav(
          gap: 8,
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          activeColor: Colors.white,
          color: Colors.grey,
          tabBackgroundColor: Colors.blue,
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Home',
            ),
            GButton(
              icon: Icons.inventory_2,
              text: 'Products',
            ),
            GButton(
              icon: Icons.person,
              text: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
