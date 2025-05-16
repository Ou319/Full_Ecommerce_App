import 'package:ecomme_app/presentation/cartShop/shopIcon.dart';
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
      backgroundColor: AppColor.white,
      appBar: AppBar(
        title: Text(
          AppString.Store,
          style: GoogleFonts.poppins(
            fontSize: Appsize.a26,
            fontWeight: FontWeight.bold,
            color: AppColor.black,
          ),
        ),
        actions: [ShopIcon(color: AppColor.black)],
        backgroundColor: AppColor.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColor.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(Appsize.a10),
        child: ProductCategoryView(),
      ),
    );
  }
}

class ProductCategoryView extends StatefulWidget {
  const ProductCategoryView({super.key});

  @override
  State<ProductCategoryView> createState() => _ProductCategoryViewState();
}

class _ProductCategoryViewState extends State<ProductCategoryView> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> products = [];
  int? selectedCategoryId;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      await _fetchCategories();
      if (categories.isNotEmpty) {
        selectedCategoryId = categories[0]['id'];
        await _fetchProducts();
      }
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await supabase
          .from('Categories')
          .select()
          .order('id', ascending: true);

      setState(() {
        categories = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load categories';
      });
      rethrow;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    if (selectedCategoryId == null) return;

    setState(() {
      isLoading = true;
      hasError = false;
      products = [];
    });

    try {
      final response = await supabase
          .from('producte')
          .select('''*, Categories:categoryrelated(name)''')
          .eq('categoryrelated', selectedCategoryId!)
          .order('created_at', ascending: false);

      setState(() {
        products = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load products';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleCategorySelect(int categoryId) {
    if (selectedCategoryId == categoryId) return;
    
    setState(() {
      selectedCategoryId = categoryId;
    });
    _fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
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

        // Category tabs
        SizedBox(
          height: 50,
          child: categories.isEmpty
              ? const SizedBox()
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category['id'] == selectedCategoryId;

                    return GestureDetector(
                      onTap: () => _handleCategorySelect(category['id']),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                            width: 60,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            category['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColor.blue : AppColor.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 3,
                            width: 60,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColor.blue : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // Brands section - Added here
        if (selectedCategoryId != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Shapebrands(categoryId: selectedCategoryId!),
          ),

        const SizedBox(height: 10),

        // Main content area
        Expanded(
          child: _buildContentSection(),
        ),
      ],
    );
  }

  Widget _buildContentSection() {
    if (isLoading && products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (categories.isEmpty) {
      return Center(
        child: Text(
          'No categories found',
          style: GoogleFonts.poppins(color: Colors.black54),
        ),
      );
    }

    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products available in this category',
          style: GoogleFonts.poppins(color: Colors.black54),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        final categoryName = (product['Categories'] as Map<String, dynamic>?)?['name'] ?? '';

        return Shapeproducte(
          rating: double.tryParse(product['rating']?.toString() ?? '0') ?? 0.0,
          title: product['name'] ?? 'No Name',
          type: categoryName,
          price: double.tryParse(product['price']?.toString() ?? '0') ?? 0.0,
          imageAsset: product['picture'] ?? '',
        );
      },
    );
  }
}

class Shapebrands extends StatefulWidget {
  final int categoryId;
  const Shapebrands({super.key, required this.categoryId});

  @override
  State<Shapebrands> createState() => _ShapebrandsState();
}

class _ShapebrandsState extends State<Shapebrands> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> marks = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchMarks();
  }

  Future<void> _fetchMarks() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await supabase
          .from('Marks')
          .select()
          .eq('category', widget.categoryId)
          .order('name', ascending: true);

      setState(() {
        marks = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        hasError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (hasError) {
      return const Center(child: Text('Failed to load brands'));
    }

    if (marks.isEmpty) {
      return const Center(child: Text('No brands available for this category'));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: marks.length,
      itemBuilder: (context, index) {
        final brand = marks[index];
        return _buildBrandItem(brand);
      },
    );
  }

  Widget _buildBrandItem(Map<String, dynamic> brand) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 60,
          height: 40,
          decoration: BoxDecoration(
            image: brand['logo'] != null 
                ? DecorationImage(
                    image: NetworkImage(brand['logo']),
                    fit: BoxFit.contain,
                  )
                : null,
          ),
          child: brand['logo'] == null 
              ? const Icon(Icons.business, size: 30)
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          brand['name'] ?? 'Unknown Brand',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (brand['nbrProducte'] != null)
          Text(
            '${brand['nbrProducte']} products',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}