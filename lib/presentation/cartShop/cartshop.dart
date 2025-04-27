import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecomme_app/app/provider/Buyproductes.dart';

class CartShop extends StatefulWidget {
  const CartShop({Key? key}) : super(key: key);

  @override
  _CartShopState createState() => _CartShopState();
}

class _CartShopState extends State<CartShop> {
  String _selectedFilter = 'Price: Low to High';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Buyproductes>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.filter_list, color: Colors.black),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.black,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
                // Apply the selected filter
                cartProvider.applyFilter(_selectedFilter);
              },
              items: <String>[
                'Price: Low to High',
                'Price: High to Low',
                'Alphabetically: A-Z',
                'Alphabetically: Z-A',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: cartProvider.ProducteSelected.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.ProducteSelected.length,
                    itemBuilder: (context, index) {
                      final product = cartProvider.ProducteSelected[index];
                      return ProductContainer(product: product, cartProvider: cartProvider);
                    },
                  ),
                ),
                _CartSummary(cartProvider: cartProvider),
              ],
            ),
    );
  }
}

class ProductContainer extends StatefulWidget {
  final product;
  final Buyproductes cartProvider;

  const ProductContainer({Key? key, required this.product, required this.cartProvider}) : super(key: key);

  @override
  _ProductContainerState createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isClicked = !_isClicked; // Toggle the product clicked state
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        height: _isClicked ? 140 : 100, // Increase the height when clicked to show + and -
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image, Title, and Price in the same line
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.ImageAasset,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                // Product Title and Price in the same line
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.Title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text("\$ ${product.Price.toStringAsFixed(2)}", style: const TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                // Delete Button with grey background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _removeProductWithUndo(context, widget.cartProvider, product);
                    },
                  ),
                ),
              ],
            ),
            // Displaying quantity buttons if the product is clicked
            if (_isClicked) ...[
              const SizedBox(height: 10),
              _buildQuantityButtons(context, widget.cartProvider, product),
            ],
          ],
        ),
      ),
    );
  }

  // Builds the quantity buttons (+ and -)
  Widget _buildQuantityButtons(BuildContext context, Buyproductes cartProvider, product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _QuantityButton(
          icon: Icons.remove,
          onPressed: () {
            if (product.count > 1) {
              cartProvider.updateProductCount(product, product.count - 1);
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            product.count.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        _QuantityButton(
          icon: Icons.add,
          onPressed: () {
            cartProvider.updateProductCount(product, product.count + 1);
          },
        ),
      ],
    );
  }

  // Function to handle the removal of a product with undo action
  void _removeProductWithUndo(BuildContext context, Buyproductes cartProvider, product) {
    cartProvider.removeProduct(product);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Product removed from cart"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            cartProvider.addProduct(product);
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.blue),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final Buyproductes cartProvider;

  const _CartSummary({required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5)),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$ ${cartProvider.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // TODO: Add checkout functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Proceeding to checkout...")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Proceed to Checkout',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
