import 'package:ecomme_app/view/homePages/home/pages/Container.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Buyproductes with ChangeNotifier {
  String text = "";
  List<Mycontainer2> ProducteSelected = [];
  
 // do it when the class created 
  Buyproductes() {
    loadProducts(); // start when and get the the save producte on open app

  }

  int get productCount => ProducteSelected.length;

  //
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedProducts = prefs.getString('saved_products');
    
    if (savedProducts != null) {
      
      final List<dynamic> decodedData = json.decode(savedProducts);
      ProducteSelected = decodedData.map((item) => Mycontainer2(
        Price: item['price'],
        Title: item['title'],
        Type: item['type'],
        ImageAasset: item['imageAsset'],
      )).toList();
      
      notifyListeners();
    }
  }

  Future<void> _saveProducts() async {
    final prefs = await SharedPreferences.getInstance();
    
  
    final List<Map<String, dynamic>> productsData = ProducteSelected.map((product) => {
      'price': product.Price,
      'title': product.Title,
      'type': product.Type,
      'imageAsset': product.ImageAasset,
    }).toList();
    
    await prefs.setString('saved_products', json.encode(productsData));
  }

  void addProducte(Mycontainer2 Producte) {
    ProducteSelected.add(Producte);
    _saveProducts(); 
    notifyListeners();
  }

  void removeProducte(Mycontainer2 Producte) {
    ProducteSelected.remove(Producte);
    _saveProducts();
    notifyListeners();
  }
}