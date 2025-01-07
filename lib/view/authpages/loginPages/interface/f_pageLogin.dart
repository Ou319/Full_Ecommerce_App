import 'package:ecomme_app/view/authpages/loginPages/interface/button/button.dart';
import 'package:ecomme_app/view/authpages/loginPages/interface/input/input.dart';
import 'package:ecomme_app/view/authpages/signuPpages/interfaces/SignUppage.dart';
import 'package:ecomme_app/view/authpages/sucsessAccount/main.dart';
import 'package:ecomme_app/view/homePages/home/homapage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class F_Pagelogin extends StatefulWidget {
  const F_Pagelogin({super.key});

  @override
  State<F_Pagelogin> createState() => _F_PageloginState();
}

class _F_PageloginState extends State<F_Pagelogin> {
  void login() {
    print("good for now");
  }

  final TextEditingController Emailcontroller = TextEditingController();
  final TextEditingController Passwordcontroller = TextEditingController();
  final googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Lottie.network(
                        "https://lottie.host/3324b46a-94a6-44cc-b9ee-79c542fb6c6d/FWLaqL10lx.json",
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover),
                  ),
                ],
              ),
              // welcome
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "welcome",
                      style: GoogleFonts.inder(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //description
                    Text(
                      """Discover the best over from over 1,000 shop 
and fast delivery to your doorstep""",
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              //input email
              SizedBox(
                height: 0,
              ),
              Column(
                children: [
                  InputAuth(
                    TextInput: "E-Mail",
                    iconInput: Icon(Icons.send),
                    controllerName: Emailcontroller,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //input password
                  InputAuth(
                    TextInput: "Password",
                    iconInput: Icon(
                      Icons.scatter_plot_outlined,
                    ),
                    controllerName: Passwordcontroller,
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forget Password? ",
                      style: GoogleFonts.inder(
                        color: const Color.fromARGB(255, 5, 65, 114),
                      ),
                    )
                  ],
                ),
              ),

              // this is for button
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () async {
                        // login with email and password
                        try {
                          final response = await Supabase.instance.client.auth
                              .signInWithPassword(
                            email: Emailcontroller.text,
                            password: Passwordcontroller.text,
                          );
                          //see is there's any errores
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Main()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("you'r login now")),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      "invalide Login try another email or password!")),
                            );
                          }
                        }
                      },
                      child: Button(
                          isBorder: false,
                          textInput: "Loge in",
                          colorBg: Colors.blue)),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Signuppage()));
                    },
                    child: Button(
                        isBorder: true,
                        textInput: "Create Account",
                        colorBg: Colors.transparent),
                  ),
                ],
              ),

              Padding(
                padding: EdgeInsets.only(top: 18.0, right: 68, left: 68),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('OR'),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // here where he can login with gougle
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Image.network(
                            "https://img.icons8.com/?size=100&id=17949&format=png&color=000000"),
                      ),
                    ),
                    SizedBox(
                      width: 17,
                    ),
                    GestureDetector(
                      onTap: () async {
                        // here where he can login with gougle
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Image.network(
                            "https://img.icons8.com/?size=100&id=118497&format=png&color=000000"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
