import 'package:ecomme_app/datalist/categories/Popularcategory.dart';
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

void main() {
  runApp(const MyApp());
}



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
          // User greeting section
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
              ShopIcon(color: Colors.black)
            ],
          ),
          const SizedBox(height: Appsize.a36),

          // Search bar section
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

          // Categories section inside the border
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

class DBCategoryDetailsPage extends StatelessWidget {
  final Map<String, dynamic> category;

  const DBCategoryDetailsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category['name'] ?? 'Category Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (category['picture'] != null)
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.network(
                  category['picture'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.red, size: 60);
                  },
                ),
              ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                category['description'] ?? 'No description available',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DealsOfTheDayWidget extends StatelessWidget {
  const DealsOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColor.blue.withOpacity(0.1),
              border: Border.all(color: AppColor.blue.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(
                'Special Offers Coming Soon!',
                style: GoogleFonts.poppins(
                  color: AppColor.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}