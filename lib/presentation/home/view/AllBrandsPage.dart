import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllBrandsPage extends StatefulWidget {
  const AllBrandsPage({super.key});

  @override
  State<AllBrandsPage> createState() => _AllBrandsPageState();
}

class _AllBrandsPageState extends State<AllBrandsPage> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> brands = [];
  List<Map<String, dynamic>> filteredBrands = [];
  bool isLoading = true;
  bool isFilterOpen = false;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  String sortBy = 'newest'; // Default sort by newest

  @override
  void initState() {
    super.initState();
    _fetchBrands();
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

  void _applyFilters() {
    List<Map<String, dynamic>> tempList = List.from(brands);
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      tempList = tempList.where((brand) {
        final name = brand['name']?.toString().toLowerCase() ?? '';
        return name.contains(searchQuery);
      }).toList();
    }
    
    // Apply sorting
    switch (sortBy) {
      case 'newest':
        tempList.sort((a, b) => b['created_at'].compareTo(a['created_at']));
        break;
      case 'oldest':
        tempList.sort((a, b) => a['created_at'].compareTo(b['created_at']));
        break;
      case 'name_asc':
        tempList.sort((a, b) => (a['name'] ?? '').toString().compareTo((b['name'] ?? '').toString()));
        break;
      case 'name_desc':
        tempList.sort((a, b) => (b['name'] ?? '').toString().compareTo((a['name'] ?? '').toString()));
        break;
      case 'products':
        tempList.sort((a, b) {
          final aProducts = int.tryParse(a['nbrProducte']?.toString() ?? '0') ?? 0;
          final bProducts = int.tryParse(b['nbrProducte']?.toString() ?? '0') ?? 0;
          return bProducts.compareTo(aProducts);
        });
        break;
    }
    
    setState(() {
      filteredBrands = tempList;
    });
  }

  void _resetFilters() {
    setState(() {
      sortBy = 'newest';
      _searchController.clear();
      filteredBrands = List.from(brands);
    });
  }

  Future<void> _fetchBrands() async {
    try {
      final response = await supabase
          .from('Marks')
          .select('*')
          .order('created_at', ascending: false);

      setState(() {
        brands = List<Map<String, dynamic>>.from(response);
        filteredBrands = List.from(brands);
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading brands: $e')),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final crossAxisCount = isSmallScreen ? 2 : 3;
    final childAspectRatio = isSmallScreen ? 2.5 : 3.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Brands',
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
                  hintText: 'Search brands...',
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
            height: isFilterOpen ? size.height * 0.25 : 0,
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
                            _buildDropdownItem('name_asc', 'Name: A to Z', Icons.sort_by_alpha),
                            _buildDropdownItem('name_desc', 'Name: Z to A', Icons.sort_by_alpha),
                            _buildDropdownItem('products', 'Most Products', Icons.inventory_2),
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
          
          // Brands grid
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredBrands.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: size.width * 0.12, color: Colors.grey[400]),
                            SizedBox(height: size.height * 0.02),
                            Text(
                              'No brands found',
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
                        itemCount: filteredBrands.length,
                        itemBuilder: (context, index) {
                          final brand = filteredBrands[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.15,
                                  height: size.width * 0.15,
                                  margin: EdgeInsets.all(size.width * 0.02),
                                  child: brand['logo'] != null
                                      ? Lottie.network(
                                          brand['logo'],
                                          width: size.width * 0.1,
                                          height: size.width * 0.1,
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Icon(Icons.business, color: Colors.blue, size: size.width * 0.1);
                                          },
                                        )
                                      : Icon(Icons.business, color: Colors.blue, size: size.width * 0.1),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        brand['name'] ?? 'Unnamed Brand',
                                        style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.035,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: size.height * 0.005),
                                      Text(
                                        '${brand['nbrProducte'] ?? '0'} Products',
                                        style: GoogleFonts.poppins(
                                          fontSize: size.width * 0.03,
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