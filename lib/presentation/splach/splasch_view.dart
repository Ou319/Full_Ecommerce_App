import 'dart:async';

import 'package:ecomme_app/data/network/networkInfo.dart';
import 'package:ecomme_app/presentation/ressourses/assetsmanager.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/routesmanaget.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:flutter/material.dart';

class SplaschView extends StatefulWidget {
  final NetworkInfo networkInfo;

  const SplaschView({super.key, required this.networkInfo});

  @override
  State<SplaschView> createState() => _SplaschViewState();
}

class _SplaschViewState extends State<SplaschView> {
  
  

  Timer? _timer;

  _startDeley(){
    _timer = Timer( const Duration(seconds: 3), _goNext);
  }

  _goNext(){
    Navigator.pushReplacementNamed(context, Routes.onBoardingRoutes);
  }

  @override
void initState() {
  super.initState();

  widget.networkInfo.isConnected.then((connected) {
    if (connected) {
      _startDeley();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppString.noInternet),
        ),
      );
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.transparent,
      body: Container(
        child: Center(
          child: Container(width: 200, child: Image.asset(AppImg.splashLogo)),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
}