import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMarks();
  }

  Future<void> _fetchMarks() async {
    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final response = await supabase
          .from('Marks')
          .select('id, name, logo, nbrProducte, description')
          .eq('category', widget.categoryId)
          .order('name', ascending: true);

      if (response.isEmpty) {
        setState(() {
          marks = [];
          isLoading = false;
        });
        return;
      }

      setState(() {
        marks = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to load brands: ${e.toString()}';
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
      return const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (hasError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _fetchMarks,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    if (marks.isEmpty) {
      return const Center(
        child: Text(
          'No brands available for this category',
          style: TextStyle(color: Colors.grey),
        ),
      );
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Handle brand tap
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand logo with proper error handling
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: brand['logo'] != null && brand['logo'].toString().isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          brand['logo'],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.broken_image, size: 24),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.business, size: 24),
                      ),
              ),
              const SizedBox(height: 8),
              // Brand name
              Text(
                brand['name']?.toString() ?? 'Unknown Brand',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Number of products if available
              if (brand['nbrProducte'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '${brand['nbrProducte']} products',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}