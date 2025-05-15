import 'dart:async';


import 'package:ecomme_app/presentation/base/baseviewmodel.dart';
import 'package:ecomme_app/presentation/favorite/favoriteview.dart';
import 'package:ecomme_app/presentation/home/view/home.dart';
import 'package:ecomme_app/presentation/profile/profile.dart';
import 'package:ecomme_app/presentation/store/view/storeview.dart';
import 'package:flutter/cupertino.dart';

class Navigationbottombarmodel extends Baseviewmodel implements Naviagationbottombarinputs, Naviagationbottombaroutputs {

  // here 
  int _selectIndex = 0;
  StreamController _streamController = StreamController<int>.broadcast();
  late final List<Widget> _pages;

  late final PageController _pageController;

PageController get pageController => _pageController;


  @override
  void dispose() {
    _streamController.close();
    
  }

  @override
  void start() {
    _pageController = PageController(initialPage: _selectIndex);
    _pages = [Home(),Storeview() ,Favoriteview(), Profile()];
  }
  
  @override
  void selectedIndex(int index) {
    _selectIndex=index;
    _streamController.add(index);
  }
  
  @override
  Stream<int> get outputsselctedindex => _streamController.stream.map((index) => index);

  
  List<Widget> get pages => _pages;
  int get currentIndex => _selectIndex;

}


abstract class Naviagationbottombarinputs{
  void selectedIndex(int index);


}

abstract class Naviagationbottombaroutputs{
  
  Stream<int> get outputsselctedindex;
}