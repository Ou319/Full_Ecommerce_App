import 'package:ecomme_app/data/network/networkInfo.dart';
import 'package:ecomme_app/presentation/favorite/favoriteview.dart';
import 'package:ecomme_app/presentation/forgetpassword/forgetpassword.dart';
import 'package:ecomme_app/presentation/home/view/home.dart';
import 'package:ecomme_app/presentation/login/view/login.dart';
import 'package:ecomme_app/presentation/navigationbottombar/view/navigationbottombar.dart';
import 'package:ecomme_app/presentation/oboarding/view/onboardingview.dart';
import 'package:ecomme_app/presentation/productdetails/productdetails.dart';
import 'package:ecomme_app/presentation/register/register.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:ecomme_app/presentation/splach/splasch_view.dart';
import 'package:ecomme_app/presentation/store/storeview.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Routes{
  static const String splaschRoutes="/";
  static const String onBoardingRoutes="/onboarding";
  static const String loginRoutes="/login";
  static const String registerRoutes="/register";
  static const String forgetPasswordRoutes="/forgetpassword";
  static const String homeRoutes="/home";
  static const String naviagationbottombar="/naviagationbottombar";
  static const String storeRoutes="/store";
  static const String productDetailsRoutes="/productdetails";
  static const String cartRoutes="/cart";
  static const String profileRoutes="/profile";
  static const String favorite="/favorite";

}

class Routganarator{
  static Route<dynamic> getRoute(RouteSettings setting){
    switch(setting.name){
      case Routes.splaschRoutes:
        final networkInfo = NetworkInfoImpl(InternetConnectionChecker.createInstance());
        return MaterialPageRoute(builder: (_) => SplashView(networkInfo: networkInfo,));
      case Routes.loginRoutes:
        return MaterialPageRoute(builder: (_) => const Login());
      case Routes.naviagationbottombar:
        return MaterialPageRoute(builder: (_) => const NavigationBottomBar());
      case Routes.onBoardingRoutes:
        return MaterialPageRoute(builder: (_) => const Onboardingview());
      case Routes.registerRoutes:
        return MaterialPageRoute(builder: (_) => const Register());
      case Routes.forgetPasswordRoutes:
        return MaterialPageRoute(builder: (_) => const Forgetpassword());
      case Routes.homeRoutes:
        return MaterialPageRoute(builder: (_) => const Home());
      case Routes.storeRoutes:
        return MaterialPageRoute(builder: (_) => const Storeview());
      case Routes.productDetailsRoutes:
        return MaterialPageRoute(builder: (_) => const Productdetails());
      case Routes.favorite:
        return MaterialPageRoute(builder: (_) => const Favoriteview());
       default:
      return UndefindRoute(); 
      
    }
  }

  static Route<dynamic> UndefindRoute(){
    return MaterialPageRoute(builder: (_) => const Scaffold(
      body: Center(
        child: Text(AppString.pagenotFound),
      ),
    ));
  }
}