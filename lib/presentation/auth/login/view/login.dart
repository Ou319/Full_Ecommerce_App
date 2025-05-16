import 'package:ecomme_app/app/supabase_auth_service.dart';
import 'package:ecomme_app/presentation/admindashbord/screens/homepage.dart';
import 'package:ecomme_app/presentation/admindashbord/screens/navigationbottombaradmin.dart';
import 'package:ecomme_app/presentation/auth/sign%20up/signup.dart';
import 'package:ecomme_app/presentation/navigationbottombar/view/navigationbottombar.dart';
import 'package:ecomme_app/presentation/ressourses/assetsmanager.dart';
import 'package:ecomme_app/presentation/ressourses/button.dart';
import 'package:ecomme_app/presentation/ressourses/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class F_Pagelogin extends StatefulWidget {
  const F_Pagelogin({super.key});

  @override
  State<F_Pagelogin> createState() => _F_PageloginState();
}

class _F_PageloginState extends State<F_Pagelogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final _authService = SupabaseAuthService();

Future<void> _login() async {
  setState(() => _isLoading = true);
  final error = await _authService.login(
    email: _emailController.text.trim(),
    password: _passwordController.text.trim(),
  );

  if (error != null) {
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  } else {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();

      final role = response['role'];

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Navigationbottombaradmin()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationBottomBar()),
        );
      }
    } else {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User not found")));
    }
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
                      "Welcome",
                      style: GoogleFonts.inder(fontSize: 30),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      """Discover the best over from over 1,000 shop 
  and fast delivery to your doorstep""",
                      style: GoogleFonts.ibmPlexSans(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  InputAuth(
                    TextInput: "Email",
                    iconInput: const Icon(Icons.email),
                    controllerName: _emailController,
                  ),
                  const SizedBox(height: 30),
                  InputAuth(
                    TextInput: "Password",
                    iconInput: const Icon(Icons.lock),
                    controllerName: _passwordController,
                    // obscureText: true,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: GoogleFonts.inder(
                        color: const Color.fromARGB(255, 5, 65, 114),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  _isLoading
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                          onTap: _login,
                          child: Button(
                            isBorder: false,
                            textInput: "Login",
                            colorBg: Colors.blue,
                          ),
                        ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Signuppage()),
                      );
                    },
                    child: Button(
                      isBorder: true,
                      textInput: "Create Account",
                      colorBg: Colors.transparent,
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 68, vertical: 18),
                child: Row(
                  children: [
                    const Expanded(
                        child: Divider(color: Colors.black, thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('OR'),
                    ),
                    const Expanded(
                        child: Divider(color: Colors.black, thickness: 1)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialIcon(
                      "https://img.icons8.com/?size=100&id=17949&format=png&color=000000"),
                  const SizedBox(width: 17),
                  _buildSocialIcon(
                      "https://img.icons8.com/?size=100&id=118497&format=png&color=000000"),
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
