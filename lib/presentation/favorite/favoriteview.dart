import 'package:ecomme_app/app/provider/Likedproducte.dart';
import 'package:ecomme_app/presentation/producte/shapeProducte.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../domain/model/modeles.dart';

class Favoriteview extends StatefulWidget {
  const Favoriteview({super.key});

  @override
  State<Favoriteview> createState() => _FavoriteviewState();
}

class _FavoriteviewState extends State<Favoriteview> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Consumer<LikedProductes>(
      builder: (context, likedProductsProvider, child) {
        final likedProducts = likedProductsProvider.likedProducts;

        final filteredProducts = selectedCategory == null
            ? likedProducts
            : likedProducts
                .where((product) => product.category == selectedCategory)
                .toList();

        return Scaffold(
          backgroundColor: Colors.white, 
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('Favorites'),
            actions: [
              if (likedProducts.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_sweep),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Clear all favorites?'),
                        content: const Text('This will remove all products from your favorites list.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('CANCEL'),
                          ),
                          TextButton(
                            onPressed: () {
                              likedProductsProvider.clearLikedProducts();
                              Navigator.pop(context);
                            },
                            child: const Text('CLEAR'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
          body: likedProducts.isEmpty
              ?  Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        width: 300,
                        child: Lottie.network("https://lottie.host/d1fd23f8-662d-42e0-a4e3-6c9c7829f6f2/iCwMxOEwBE.json"),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Products you like will appear here',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _buildCategoryFilter(likedProducts),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Shapeproducte(
                            price: product.Price ?? 0,
                            title: product.Title ?? "",
                            type: product.category ?? '',
                            imageAsset: product.ImageAasset ?? '',
                            rating: product.rating ?? 0,
                            isFavorit: product.isFavorit ?? false,
                            count: product.count ?? 1,
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(List<ProducteModel> products) {
    // استخراج التصنيفات المتوفرة
    final categories = products.map((e) => e.category ?? '').toSet().toList();

    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == 0
              ? selectedCategory == null
              : selectedCategory == categories[index - 1];

          final label = index == 0 ? "All" : categories[index - 1];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index == 0 ? null : categories[index - 1];
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
