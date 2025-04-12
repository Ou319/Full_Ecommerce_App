import 'dart:async';


import 'package:ecomme_app/presentation/base/baseviewmodel.dart';
import 'package:ecomme_app/presentation/favorite/favoriteview.dart';
import 'package:ecomme_app/presentation/home/home.dart';
import 'package:ecomme_app/presentation/profile/profile.dart';
import 'package:ecomme_app/presentation/store/storeview.dart';
import 'package:flutter/cupertino.dart';

class Navigationbottombarmodel extends Baseviewmodel implements Naviagationbottombarinputs, Naviagationbottombaroutputs {

  int _selectIndex = 0;
  StreamController _streamController = StreamController<int>.broadcast();
  late final List<Widget> _pages;

  @override
  void dispose() {
    _streamController.close();
    
  }

  @override
  void start() {
    _pages = [Home(), Favoriteview(), Storeview(), Profile()];
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