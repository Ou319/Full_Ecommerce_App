import 'package:ecomme_app/view/homePages/home/pages/Container.dart';
import 'package:flutter/material.dart';

 class Buyproductes with ChangeNotifier {
  // the name of the list
   String text = "";
  List<Mycontainer2> ProducteSelected=[

  
  ];
  int get productCount => ProducteSelected.length;

  
  void addProducte(Mycontainer2 Producte){
    ProducteSelected.add(Producte);
    notifyListeners();
  }


  void removeProducte(Mycontainer2 Producte){
    ProducteSelected.remove(Producte);
    notifyListeners();
  }
}