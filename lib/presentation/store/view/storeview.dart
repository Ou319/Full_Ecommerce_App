import 'package:ecomme_app/presentation/cartShop/shopIcon.dart';
import 'package:ecomme_app/presentation/home/view/AllProductsPage.dart';
import 'package:ecomme_app/presentation/producte/shapeProducte.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:ecomme_app/presentation/ressourses/valuesmanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Storeview extends StatefulWidget {
  const Storeview({super.key});

  @override
  State<Storeview> createState() => _StoreviewState();
}

class _StoreviewState extends State<Storeview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppString.Store,
          style: GoogleFonts.poppins(
            fontSize: Appsize.a26,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        actions: [
          ShopIcon(color: AppColor.black),
        ],
        
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.black),
      ),
      backgroundColor: AppColor.white,
      body: Padding(
        padding: EdgeInsets.all(Appsize.a10),
        child: Column(
          children: [
            // 🔍 Search bar
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColor.textmd),
                borderRadius: BorderRadius.circular(Appsize.a10),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppString.Search_in_store,
                  hintStyle: TextStyle(color: AppColor.textmd),
                  prefixIcon: const Icon(Icons.search, color: AppColor.textmd),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Expanded(child: ProductListWidget()),
          ],
        ),
      ),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({super.key});

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  final supabase = Supabase.instance.client;
  List<dynamic> productList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase
          .from('producte')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        productList = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (productList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No products available.',
          style: GoogleFonts.poppins(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🏷️ Title + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Products',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllProductsPage(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 🧱 Product Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              return Shapeproducte(
                rating: double.tryParse(product['rating'].toString()) ?? 0.0,
                title: product['name'] ?? 'No Name',
                type: product['category'] ?? '',
                price: double.tryParse(product['price'].toString()) ?? 0.0,
                imageAsset: product['picture'] ?? '',
              );
            },
          ),
        ],
      ),
    );
  }
}
