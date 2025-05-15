import 'dart:async';
import 'package:ecomme_app/app/supabase_auth_service.dart';
import 'package:ecomme_app/datalist/categories/Popularcategory.dart';
import 'package:ecomme_app/presentation/home/view/AllProductsPage.dart';
import 'package:ecomme_app/presentation/home/view/AllBrandsPage.dart';
import 'package:ecomme_app/presentation/home/view/DBCategoryDetailsPage.dart';
import 'package:ecomme_app/presentation/producte/shapeProducte.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/textmanager.dart';
import 'package:ecomme_app/presentation/ressourses/valuesmanager.dart';
import 'package:ecomme_app/presentation/cartShop/shopIcon.dart';
import 'package:ecomme_app/app/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<CategoryModel> categories = CategoriesData.getCategories();
  bool isLoading = true;
  List<Map<String, dynamic>> dbCategories = [];
  final supabase = Supabase.instance.client;
  final _authresponsefullname= SupabaseAuthService();
  String fullName = 'Loading...';

  Future<void> _fetchUserFullName() async {
  final getFullname= await _authresponsefullname.getFullName();
  
  setState(() {
    fullName = getFullname ?? 'Loading...';
  });
    
  }


  Future<void> _fetchCategories() async {
    try {
      final response = await supabase
          .from('Categories')
          .select('*')
          .order('created_at', ascending: true);

      if (response != null) {
        setState(() {
          dbCategories = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchUserFullName();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              HeaderWidget(
                categories: categories,
                dbCategories: dbCategories,
                isLoading: isLoading,
                fullName: fullName,
              ),
              const SizedBox(height: 20),
              const BrandsWidget(),
              const SizedBox(height: 20),
              const ProductListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final List<CategoryModel> categories;
  final List<Map<String, dynamic>> dbCategories;
  final bool isLoading;
  final String fullName;

  const HeaderWidget({
    super.key,
    required this.categories,
    required this.dbCategories,
    required this.isLoading,
    required this.fullName
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: AppColor.transparent,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: Appsize.a36),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppString.good_day_for_shoping,
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    fullName,

                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ShopIcon(color: Colors.black),
            ],
          ),
          const SizedBox(height: Appsize.a36),
          SizedBox(
            height: 120,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: dbCategories.length,
                    itemBuilder: (context, index) {
                      final category = dbCategories[index];
                      return DBCategoryItemWidget(category: category);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DBCategoryItemWidget extends StatelessWidget {
  final Map<String, dynamic> category;

  const DBCategoryItemWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToCategoryDetails(context, category),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: category['picture'] != null
                      ? Lottie.network(
                          category['picture'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.category, color: AppColor.blue);
                          },
                        )
                      : Icon(Icons.category, color: AppColor.blue),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category['name'] ?? 'Unnamed Category',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategoryDetails(
      BuildContext context, Map<String, dynamic> category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DBCategoryDetailsPage(category: category),
      ),
    );
  }
}

// New Brands Widget
class BrandsWidget extends StatefulWidget {
  const BrandsWidget({super.key});

  @override
  State<BrandsWidget> createState() => _BrandsWidgetState();
}

class _BrandsWidgetState extends State<BrandsWidget> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> brands = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrands();
  }

  Future<void> _fetchBrands() async {
    try {
      final response = await supabase
          .from('Marks')
          .select('*')
          .order('created_at', ascending: false)
          .limit(4); // Limit to 4 brands

      setState(() {
        brands = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching brands: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (brands.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No brands available.',
          style: GoogleFonts.poppins(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Brands',
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
                      builder: (context) => const AllBrandsPage(),
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              final brand = brands[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.all(8),
                      child: brand['logo'] != null
                          ? Lottie.network(
                              brand['logo'],
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.business, color: Colors.blue);
                              },
                            )
                          : const Icon(Icons.business, color: Colors.blue),
                    ),
                  
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand['name'] ?? 'Unnamed Brand',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${brand['nbrProducte'] ?? '0'} Products',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// 🆕 New Product List section
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.65,
            ),
            itemCount: productList.length,
            itemBuilder: (context, index) {
              final product = productList[index];
              // return ProductItemWidget(product: product);
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

