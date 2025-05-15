import 'package:ecomme_app/app/supabase_auth_service.dart';
import 'package:ecomme_app/presentation/home/view/home.dart';
import 'package:ecomme_app/presentation/navigationbottombar/view/navigationbottombar.dart';
import 'package:ecomme_app/presentation/ressourses/assetsmanager.dart';
import 'package:ecomme_app/presentation/ressourses/button.dart';
import 'package:ecomme_app/presentation/ressourses/input.dart';
import 'package:ecomme_app/presentation/ressourses/routesmanaget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final _authService = SupabaseAuthService();
  Future<void> _signUp() async {
  final error = await _authService.signUp(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
    fullName: _usernameController.text.trim(),
  );

  if (error != null) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  } else {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationBottomBar()),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: Image.asset(
                      AppImg.splashLogo,
                      height: 100,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's Create Your Account",
                      style: GoogleFonts.inder(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      """Discover the best offer from over 1,000 shops 
and fast delivery to your doorstep""",
                      style: GoogleFonts.ibmPlexSans(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  InputAuth(
                    controllerName: _usernameController,
                    TextInput: "Username",
                    iconInput: const Icon(Icons.person_outline),
                  ),
                  const SizedBox(height: 20),
                  InputAuth(
                    controllerName: _emailController,
                    TextInput: "Email",
                    iconInput: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 20),
                  InputAuth(
                    controllerName: _passwordController,
                    TextInput: "Password",
                    iconInput: const Icon(Icons.lock),
                  //  obscureText: true,  // Uncommented for password hiding
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, top: 3),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacementNamed(
                        context,
                        Routes.loginRoutes,
                      ),
                      child: Text(
                        "Have Account? Log in now",
                        style: GoogleFonts.inder(
                          color: const Color.fromARGB(255, 5, 65, 114),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : GestureDetector(
                      onTap: _signUp,
                      child: Button(
                        isBorder: false,
                        textInput: "Sign Up",
                        colorBg: Colors.blue,
                      ),
                    ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 68.0, vertical: 18.0),
                child: Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.black, thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('OR'),
                    ),
                    const Expanded(child: Divider(color: Colors.black, thickness: 1)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon("https://img.icons8.com/?size=100&id=17949&format=png&color=000000"),
                  const SizedBox(width: 17),
                  _buildSocialIcon("https://img.icons8.com/?size=100&id=118497&format=png&color=000000"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String url) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Image.network(url),
    );
  }
}