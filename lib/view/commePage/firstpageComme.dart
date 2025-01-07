import 'package:ecomme_app/view/authpages/loginPages/interface/f_pageLogin.dart';
import 'package:ecomme_app/view/commePage/mylistPageview.dart';
import 'package:ecomme_app/view/homePages/constant/naviagationBottombar/naviagationBottombar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FisrtPageComme extends StatefulWidget {
  const FisrtPageComme({super.key});

  @override
  State<FisrtPageComme> createState() => _FisrtPageCommeState();
}

class _FisrtPageCommeState extends State<FisrtPageComme> {
  void _checkAuthStatus() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Naviagationbottombar()), 
      );
    } else {
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => F_Pagelogin()), 
      );
    }
  }
  final PageController controllerpageview = PageController();
  bool isTowpage = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _checkAuthStatus();
            },
            child: Container(
              margin: EdgeInsets.only(left: 420,top: 50),
              child: Text(
                "Skip",
                style: GoogleFonts.ibmPlexSans(
                    fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 700),
            child: Expanded(
              child: PageView.builder(
                controller: controllerpageview,
                itemCount: mylistpageview.length,
                itemBuilder: (context, index) {
                  final item = mylistpageview[index];
                  return Padding(
                    // margin: const EdgeInsets.all(8.0
                    padding: const EdgeInsets.only(top: 80.0),

                    child: Stack(
                      children: [
                        Positioned(
                          child: Center(
                              child: Lottie.network(item.url,
                                  height: 500, width: 500, fit: BoxFit.cover)),
                          right: isTowpage ? 0 : 100,
                        ),
                        Positioned(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 300,
                              ),
                              Center(
                                child: Text(
                                  item.title,
                                  style: GoogleFonts.roboto(
                                    fontSize: 33,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  item.subtitle,
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 20,
                                    color: Colors.black45,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onPageChanged: (value) {
                  setState(() {
                    currentIndex = value;
                    if (value == 1) {
                      isTowpage = true;
                    } else {
                      isTowpage = false;
                    }
                  });
                },
              ),
            ),
          ),
          Container(
            // height: 100,
            margin: EdgeInsets.only(bottom: 70),
            child: // height: 20),
                Padding(
              padding: const EdgeInsets.only(left: 48.0, bottom: 30),
              child: Row(
                children: [
                  for (int i = 0; i < mylistpageview.length; i++)
                    Mycontainer(currentIndex == i),
                ],
              ),
            ),
          ),
          
        ],
      ),
      floatingActionButton: Container(
        // height: 100,
        margin: EdgeInsets.only(bottom: 63, right: 20),
        child: FloatingActionButton(
          onPressed: () {
            if (currentIndex == 2) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => F_Pagelogin()));
            } else {
              controllerpageview.nextPage(
                  duration: Duration(milliseconds: 700), curve: Curves.easeIn);
            }
          },
          shape: CircleBorder(),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
          elevation: 0,
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  Widget Mycontainer(bool isNextpage) {
    return AnimatedContainer(
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(
        right: 5,
      ),
      duration: Duration(milliseconds: 700),
      width: isNextpage ? 54 : 20,
      height: 4,
      decoration: BoxDecoration(
        color: isNextpage ? Colors.black : Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
