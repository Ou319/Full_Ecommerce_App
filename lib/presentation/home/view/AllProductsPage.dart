import 'package:ecomme_app/presentation/producte/shapeProducte.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllProductsPage extends StatefulWidget {
  const AllProductsPage({super.key});

  @override
  State<AllProductsPage> createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final supabase = Supabase.instance.client;
  List<dynamic> productList = [];
  List<dynamic> filteredProducts = [];
  bool isLoading = true;
  bool isFilterOpen = false;
  
  // Filter variables
  List<String> categories = [];
  String? selectedCategory;
  RangeValues priceRange = const RangeValues(0, 1000);
  double maxPrice = 1000;
  String sortBy = 'newest';
  
  // Search
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
      _applyFilters();
    });
  }

  Future<void> fetchProducts() async {
    try {
      final response = await supabase
          .from('producte')
          .select()
          .order('created_at', ascending: false);
      
      // Extract unique categories
      final Set<String> uniqueCategories = {};
      for (var product in response) {
        if (product['category'] != null) {
          uniqueCategories.add(product['category'].toString());
        }
      }
      
      // Find maximum price
      double max = 0;
      for (var product in response) {
        final price = double.tryParse(product['price'].toString()) ?? 0;
        if (price > max) max = price;
      }

      setState(() {
        productList = response;
        filteredProducts = List.from(response);
        categories = uniqueCategories.toList();
        maxPrice = max;
        priceRange = RangeValues(0, max);
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<dynamic> tempList = List.from(productList);
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      tempList = tempList.where((product) =>
        product['name'].toString().toLowerCase().contains(searchQuery) ||
        product['category'].toString().toLowerCase().contains(searchQuery)
      ).toList();
    }
    
    // Apply category filter
    if (selectedCategory != null) {
      tempList = tempList.where((product) =>
        product['category'] == selectedCategory
      ).toList();
    }
    
    // Apply price range filter
    tempList = tempList.where((product) {
      final price = double.tryParse(product['price'].toString()) ?? 0;
      return price >= priceRange.start && price <= priceRange.end;
    }).toList();
    
    // Apply sorting
    switch (sortBy) {
      case 'newest':
        tempList.sort((a, b) => b['created_at'].compareTo(a['created_at']));
        break;
      case 'oldest':
        tempList.sort((a, b) => a['created_at'].compareTo(b['created_at']));
        break;
      case 'price_high':
        tempList.sort((a, b) {
          final priceA = double.tryParse(b['price'].toString()) ?? 0;
          final priceB = double.tryParse(a['price'].toString()) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_low':
        tempList.sort((a, b) {
          final priceA = double.tryParse(a['price'].toString()) ?? 0;
          final priceB = double.tryParse(b['price'].toString()) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'rating':
        tempList.sort((a, b) {
          final ratingA = double.tryParse(b['rating'].toString()) ?? 0;
          final ratingB = double.tryParse(a['rating'].toString()) ?? 0;
          return ratingA.compareTo(ratingB);
        });
        break;
    }
    
    setState(() {
      filteredProducts = tempList;
    });
  }

  void _resetFilters() {
    setState(() {
      selectedCategory = null;
      priceRange = RangeValues(0, maxPrice);
      sortBy = 'newest';
      _searchController.clear();
      filteredProducts = List.from(productList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Products',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                isFilterOpen = !isFilterOpen;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Filter panel (animated)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isFilterOpen ? 250 : 0,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Category filter
                  _buildFilterSection(
                    title: 'Category',
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: const Text('All'),
                          selected: selectedCategory == null,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = null;
                              _applyFilters();
                            });
                          },
                        ),
                        ...categories.map((category) => ChoiceChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = category;
                              _applyFilters();
                            });
                          },
                        )).toList(),
                      ],
                    ),
                  ),
                  
                  // Price range filter
                  _buildFilterSection(
                    title: 'Price Range',
                    child: Column(
                      children: [
                        RangeSlider(
                          values: priceRange,
                          min: 0,
                          max: maxPrice,
                          divisions: 10,
                          labels: RangeLabels(
                            '\$${priceRange.start.round()}',
                            '\$${priceRange.end.round()}',
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              priceRange = values;
                            });
                          },
                          onChangeEnd: (_) => _applyFilters(),
                        ),
                      ],
                    ),
                  ),
                  
                  // Sort options
                  _buildFilterSection(
                    title: 'Sort By',
                    child: DropdownButton<String>(
                      value: sortBy,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: 'newest',
                          child: Text('Newest First', style: GoogleFonts.poppins()),
                        ),
                        DropdownMenuItem(
                          value: 'oldest',
                          child: Text('Oldest First', style: GoogleFonts.poppins()),
                        ),
                        DropdownMenuItem(
                          value: 'price_high',
                          child: Text('Price: High to Low', style: GoogleFonts.poppins()),
                        ),
                        DropdownMenuItem(
                          value: 'price_low',
                          child: Text('Price: Low to High', style: GoogleFonts.poppins()),
                        ),
                        DropdownMenuItem(
                          value: 'rating',
                          child: Text('Highest Rating', style: GoogleFonts.poppins()),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sortBy = value!;
                          _applyFilters();
                        });
                      },
                    ),
                  ),
                  
                  // Reset filters button
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Reset Filters'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                    ),
                    onPressed: _resetFilters,
                  ),
                ],
              ),
            ),
          ),
          
          // Product grid
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: _resetFilters,
                              child: const Text('Reset filters'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Shapeproducte(
                            rating: double.tryParse(product['rating'].toString()) ?? 0.0,
                            title: product['name'] ?? 'No Name',
                            type: product['category'] ?? '',
                            price: double.tryParse(product['price'].toString()) ?? 0.0,
                            imageAsset: product['picture'] ?? '',
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}