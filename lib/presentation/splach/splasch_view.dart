import 'dart:async';

import 'package:ecomme_app/app/provider/app_prefs.dart';
import 'package:ecomme_app/data/network/networkInfo.dart';
import 'package:ecomme_app/presentation/ressourses/assetsmanager.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/routesmanaget.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashView extends StatefulWidget {
  final NetworkInfo networkInfo;

  const SplashView({super.key, required this.networkInfo});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final AppPreferences _appPreferences;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _appPreferences = AppPreferences(prefs);
    
    widget.networkInfo.isConnected.then((connected) {
      if (connected) {
        _startDelay();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppString.noInternet),
          ),
        );
      }
    });
  }

  _startDelay() {
    _timer = Timer(const Duration(seconds: 3), _goNext);
  }

  _goNext() {
    _appPreferences.iSOnBoardingScreenView().then((hasSeenOnboarding) {
      if (hasSeenOnboarding) {
        Navigator.pushReplacementNamed(context, Routes.naviagationbottombar);
      } else {
        Navigator.pushReplacementNamed(context, Routes.onBoardingRoutes);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: Center(
        child: Container(
          width: 200, 
          child: Image.asset(AppImg.splashLogo)
      ),
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}