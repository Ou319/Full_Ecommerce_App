import 'package:ecomme_app/domain/model/modeles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// this is provider here where we gonna set data(producte selected)
class Buyproductes with ChangeNotifier {
  String text = "";
  List<ProducteModel> _producteSelected = [];
  
  List<ProducteModel> get ProducteSelected => _producteSelected;
  
  // do it when the class created 
  Buyproductes() {
    loadProducts(); // start when and get the the save producte on open app
  }

  int get productCount => _producteSelected.length;

  //
  Future<void> loadProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedProducts = prefs.getString('saved_products');
      
      if (savedProducts != null) {
        final List<dynamic> decodedData = json.decode(savedProducts);
        _producteSelected = decodedData
            .map((item) => ProducteModel.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading products: $e');
    }
  }

  Future<void> _saveProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> productsData = 
          _producteSelected.map((product) => product.toJson()).toList();
      
      await prefs.setString('saved_products', json.encode(productsData));
    } catch (e) {
      debugPrint('Error saving products: $e');
    }
  }

  void addProduct(ProducteModel product) {
    if (!_producteSelected.contains(product)) {
      _producteSelected.add(product);
      _saveProducts();
      notifyListeners();
    }
  }

  void removeProduct(ProducteModel product) {
    _producteSelected.remove(product);
    _saveProducts();
    notifyListeners();
  }

  void clearProducts() {
    _producteSelected.clear();
    _saveProducts();
    notifyListeners();
  }

  void updateProductCount(ProducteModel product, int newCount) {
    final index = _producteSelected.indexOf(product);
    if (index != -1) {
      product.count = newCount;
      _saveProducts();
      notifyListeners();
    }
  }

  double get totalPrice {
    return _producteSelected.fold(0, (sum, item) => sum + (item.Price * item.count));
  }

  get addProducte => null;

  void applyFilter(String selectedFilter) {}
}