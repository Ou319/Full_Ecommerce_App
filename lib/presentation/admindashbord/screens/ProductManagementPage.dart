import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Productmanagementpage extends StatefulWidget {
  const Productmanagementpage({super.key});

  @override
  State<Productmanagementpage> createState() => _ProductmanagementpageState();
}

class _ProductmanagementpageState extends State<Productmanagementpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  bool _loading = false;

  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User not authenticated')));
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await Supabase.instance.client.from('producte').insert({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'price': double.tryParse(_priceController.text) ?? 0,
        'rating': double.tryParse(_ratingController.text) ?? 0,
        'picture': _imageController.text,
        'owner': userId,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Product added successfully')));

      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _ratingController.clear();
      _imageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Product Name'),
              const SizedBox(height: 10),
              _buildTextField(_descriptionController, 'Description'),
              const SizedBox(height: 10),
              _buildTextField(_priceController, 'Price', isNumber: true),
              const SizedBox(height: 10),
              _buildTextField(_ratingController, 'Rating', isNumber: true),
              const SizedBox(height: 10),
              _buildTextField(_imageController, 'Image URL'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _loading ? null : _addProduct,
                icon: const Icon(Icons.add),
                label: Text(_loading ? 'Adding...' : 'Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
