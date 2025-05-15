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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final crossAxisCount = isSmallScreen ? 2 : 3;
    final childAspectRatio = isSmallScreen ? 0.7 : 0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'All Products',
          style: GoogleFonts.poppins(
            fontSize: size.width * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(size.width * 0.02),
              decoration: BoxDecoration(
                color: isFilterOpen ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.filter_list,
                color: isFilterOpen ? Colors.blue : Colors.black,
                size: size.width * 0.06,
              ),
            ),
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
            padding: EdgeInsets.all(size.width * 0.04),
            child: Container(
              height: size.height * 0.06,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                    fontSize: size.width * 0.035,
                  ),
                  prefixIcon: Container(
                    padding: EdgeInsets.all(size.width * 0.03),
                    child: Icon(Icons.search, color: Colors.grey[600], size: size.width * 0.05),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey[600], size: size.width * 0.05),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
          ),
          
          // Filter panel (animated)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isFilterOpen ? size.height * 0.35 : 0,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
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
                      spacing: size.width * 0.02,
                      children: [
                        _buildFilterChip(
                          label: 'All',
                          isSelected: selectedCategory == null,
                          onSelected: (_) {
                            setState(() {
                              selectedCategory = null;
                              _applyFilters();
                            });
                          },
                        ),
                        ...categories.map((category) => _buildFilterChip(
                          label: category,
                          isSelected: selectedCategory == category,
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
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: sortBy,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600], size: size.width * 0.05),
                          items: [
                            _buildDropdownItem('newest', 'Newest First', Icons.access_time),
                            _buildDropdownItem('oldest', 'Oldest First', Icons.access_time_filled),
                            _buildDropdownItem('price_high', 'Price: High to Low', Icons.arrow_downward),
                            _buildDropdownItem('price_low', 'Price: Low to High', Icons.arrow_upward),
                            _buildDropdownItem('rating', 'Highest Rating', Icons.star),
                          ],
                          onChanged: (value) {
                            setState(() {
                              sortBy = value!;
                              _applyFilters();
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  // Reset filters button
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: size.height * 0.01),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.refresh, size: size.width * 0.045),
                      label: Text(
                        'Reset Filters',
                        style: GoogleFonts.poppins(
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      onPressed: _resetFilters,
                    ),
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
                            Icon(Icons.search_off, size: size.width * 0.12, color: Colors.grey[400]),
                            SizedBox(height: size.height * 0.02),
                            Text(
                              'No products found',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: size.width * 0.04,
                              ),
                            ),
                            TextButton(
                              onPressed: _resetFilters,
                              child: Text(
                                'Reset filters',
                                style: GoogleFonts.poppins(
                                  fontSize: size.width * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(size.width * 0.04),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: size.width * 0.03,
                          mainAxisSpacing: size.width * 0.03,
                          childAspectRatio: childAspectRatio,
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
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: size.width * 0.035,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: size.height * 0.01),
          child,
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    final size = MediaQuery.of(context).size;
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: size.width * 0.03,
          color: isSelected ? Colors.white : Colors.grey[800],
        ),
      ),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03, vertical: size.height * 0.01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.blue : Colors.grey[300]!,
          width: 1,
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String text, IconData icon) {
    final size = MediaQuery.of(context).size;
    return DropdownMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: size.width * 0.05, color: Colors.grey[600]),
          SizedBox(width: size.width * 0.02),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: size.width * 0.035,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}