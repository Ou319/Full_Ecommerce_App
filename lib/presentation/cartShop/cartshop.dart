import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 2,
        actions: [
          // Filter Dropdown
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.filter_list, color: Colors.black),
              iconSize: 22,
              elevation: 8,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              underline: Container(
                height: 1,
                color: Colors.grey[300],
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
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
          ? EmptyCartView()
          : SafeArea(
              child: Column(
                children: [
                  // Cart items count
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : size.width * 0.05,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Your Items (${cartProvider.ProducteSelected.length})',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : size.width * 0.05,
                        vertical: 8,
                      ),
                      itemCount: cartProvider.ProducteSelected.length,
                      itemBuilder: (context, index) {
                        final product = cartProvider.ProducteSelected[index];
                        return ProductContainer(
                          product: product,
                          cartProvider: cartProvider,
                          isSmallScreen: isSmallScreen,
                        );
                      },
                    ),
                  ),
                  CartSummary(
                    cartProvider: cartProvider,
                    isSmallScreen: isSmallScreen,
                  ),
                ],
              ),
            ),
    );
  }
}

class EmptyCartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isSmallScreen ? 120 : 150,
            height: isSmallScreen ? 120 : 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: 
            Lottie.network("https://lottie.host/370959ab-56a7-41ea-afc9-dbf3c8eee748/YDYVzq5xrC.json"),
          ),
          const SizedBox(height: 24),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Add items to get started",
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // Navigate to products page
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: 17,
                horizontal: isSmallScreen ? 24 : 32,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Browse Products',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductContainer extends StatefulWidget {
  final dynamic product;
  final Buyproductes cartProvider;
  final bool isSmallScreen;

  const ProductContainer({
    Key? key,
    required this.product,
    required this.cartProvider,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  _ProductContainerState createState() => _ProductContainerState();
}

class _ProductContainerState extends State<ProductContainer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image with gradient overlay
                    Container(
                      width: widget.isSmallScreen ? 70 : 90,
                      height: widget.isSmallScreen ? 70 : 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Image.network(
                              product.ImageAasset,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[200],
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey[400],
                                  size: widget.isSmallScreen ? 24 : 32,
                                ),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2,
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Product Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.Title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.isSmallScreen ? 16 : 18,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\$${product.Price.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                              fontSize: widget.isSmallScreen ? 15 : 17,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: widget.isSmallScreen ? 16 : 18,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "Quantity: ${product.count}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: widget.isSmallScreen ? 13 : 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Delete Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red[400],
                          size: widget.isSmallScreen ? 22 : 24,
                        ),
                        onPressed: () {
                          _removeProductWithUndo(context, widget.cartProvider, product);
                        },
                        constraints: BoxConstraints(
                          minWidth: widget.isSmallScreen ? 36 : 40,
                          minHeight: widget.isSmallScreen ? 36 : 40,
                        ),
                        padding: const EdgeInsets.all(8),
                        splashRadius: widget.isSmallScreen ? 20 : 24,
                      ),
                    ),
                  ],
                ),
                // Expandable section with quantity controls
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: _isExpanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Adjust Quantity:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: [
                                    QuantityButton(
                                      icon: Icons.remove,
                                      onPressed: () {
                                        if (product.count > 1) {
                                          widget.cartProvider.updateProductCount(
                                            product,
                                            product.count - 1,
                                          );
                                        }
                                      },
                                      isSmallScreen: widget.isSmallScreen,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        product.count.toString(),
                                        style: TextStyle(
                                          fontSize: widget.isSmallScreen ? 16 : 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    QuantityButton(
                                      icon: Icons.add,
                                      onPressed: () {
                                        widget.cartProvider
                                            .updateProductCount(product, product.count + 1);
                                      },
                                      isSmallScreen: widget.isSmallScreen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _removeProductWithUndo(BuildContext context, Buyproductes cartProvider, product) {
    cartProvider.removeProduct(product);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Product removed from cart",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            cartProvider.addProduct(product);
          },
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSmallScreen;

  const QuantityButton({
    required this.icon,
    required this.onPressed,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: isSmallScreen ? 32 : 36,
          height: isSmallScreen ? 32 : 36,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isSmallScreen ? 18 : 20,
            color: Colors.blue[600],
          ),
        ),
      ),
    );
  }
}

class CartSummary extends StatelessWidget {
  final Buyproductes cartProvider;
  final bool isSmallScreen;

  const CartSummary({
    required this.cartProvider,
    required this.isSmallScreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20 : 32,
        vertical: isSmallScreen ? 16 : 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order summary section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal:',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "\$${cartProvider.totalPrice.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping:',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "FREE",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tax:',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "\$${(cartProvider.totalPrice * 0.05).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 16),
            // Total price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "\$${(cartProvider.totalPrice * 1.05).toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Checkout button
            ElevatedButton(
              onPressed: () {
                // TODO: Add checkout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Proceeding to checkout..."),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Text(
                'Proceed to Checkout',
                style: TextStyle(
                  fontSize: isSmallScreen ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}