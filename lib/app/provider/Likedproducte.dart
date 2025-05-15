import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/model/modeles.dart';

class LikedProductes with ChangeNotifier {
  List<ProducteModel> _likedProducts = [];

  List<ProducteModel> get likedProducts => _likedProducts;

  LikedProductes() {
    loadLikedProducts(); 
  }

  Future<void> loadLikedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? saved = prefs.getString('liked_products');

      if (saved != null) {
        final List<dynamic> decoded = json.decode(saved);
        _likedProducts = decoded
            .map((item) => ProducteModel.fromJson(item))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading liked products: $e');
    }
  }

  Future<void> _saveLikedProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = _likedProducts.map((item) => item.toJson()).toList();
      await prefs.setString('liked_products', json.encode(data));
    } catch (e) {
      debugPrint('Error saving liked products: $e');
    }
  }

  void toggleLike(ProducteModel product) {
    final existingIndex =
        _likedProducts.indexWhere((item) => item.Title == product.Title);

    if (existingIndex != -1) {
      _likedProducts.removeAt(existingIndex); 
    } else {
      _likedProducts.add(product); 
    }
    _saveLikedProducts();
    notifyListeners();
  }

  bool isLiked(ProducteModel product) {
    return _likedProducts.any((item) => item.Title == product.Title);
  }

  void clearLikedProducts() {
    _likedProducts.clear();
    _saveLikedProducts();
    notifyListeners();
  }
}
