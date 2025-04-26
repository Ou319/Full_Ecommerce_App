import 'package:ecomme_app/presentation/producte/shapeProducte.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DBCategoryDetailsPage extends StatefulWidget {
  final Map<String, dynamic> category;

  const DBCategoryDetailsPage({super.key, required this.category});

  @override
  State<DBCategoryDetailsPage> createState() => _DBCategoryDetailsPageState();
}

class _DBCategoryDetailsPageState extends State<DBCategoryDetailsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;

  Future<void> _fetchProducts() async {
    final response = await supabase
        .from('producte')
        .select('*')
        .eq('categoryrelated', widget.category['id']);

    setState(() {
      products = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.category['name'] ?? 'Category Details'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (widget.category['picture'] != null)
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.network(
                        widget.category['picture'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, color: Colors.red, size: 60),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    widget.category['description'] ?? 'No description available',
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),

                    itemCount: products.length,
                    shrinkWrap: true,
                    //  physics: const NeverScrollableScrollPhysics(),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Shapeproducte(
                          rating: double.tryParse(product['rating'].toString()) ?? 0.0,
                          title: product['name'] ?? 'No Name',
                          type: widget.category['name'] ?? '',
                          price: double.tryParse(product['price'].toString()) ?? 0.0,
                          imageAsset: product['picture'] ?? '',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
