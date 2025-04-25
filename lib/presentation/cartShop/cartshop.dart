import 'package:flutter/material.dart';

class CartShop extends StatelessWidget {
  const CartShop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
      ),
      body: const Center(
        child: Text('Your cart is empty'),
      ),
    );
  }
}
