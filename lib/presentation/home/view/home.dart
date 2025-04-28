import 'dart:async';
import 'package:ecomme_app/datalist/categories/Popularcategory.dart';
import 'package:ecomme_app/presentation/home/view/AllProductsPage.dart';
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
              ),
              const SizedBox(height: 20),
              const DealsOfTheDayWidget(),
              const SizedBox(height: 20),
              const ProductListWidget(), // 🆕 New Products section
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

  const HeaderWidget({
    super.key,
    required this.categories,
    required this.dbCategories,
    required this.isLoading,
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
                    "OUTMANE EL OUAFA",
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
          Container(
            width: size.width,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: AppString.search_in_store,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
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

// 🔥 Deals Of The Day with Auto-Sliding
class DealsOfTheDayWidget extends StatefulWidget {
  const DealsOfTheDayWidget({super.key});

  @override
  State<DealsOfTheDayWidget> createState() => _DealsOfTheDayWidgetState();
}

class _DealsOfTheDayWidgetState extends State<DealsOfTheDayWidget> {
  final supabase = Supabase.instance.client;
  List<dynamic> newsList = [];
  bool isLoading = true;
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchNews();
    _startAutoSlide();
  }

  Future<void> fetchNews() async {
    try {
      final response = await supabase
          .from('news')
          .select()
          .order('created_at', ascending: false);
      setState(() {
        newsList = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < newsList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (newsList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'No deals available right now.',
          style: GoogleFonts.poppins(color: Colors.black54, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Deals of the Day',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        news['img'],
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          news['title'] ?? 'Untitled Deal',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
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
              childAspectRatio: 0.7,
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

