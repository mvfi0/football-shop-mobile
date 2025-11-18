// lib/shop_form.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'widgets/left_drawer.dart';
import 'screens/product_entry_list.dart';

class ShopFormPage extends StatefulWidget {
  const ShopFormPage({super.key});

  @override
  State<ShopFormPage> createState() => _ShopFormPageState();
}

class _ShopFormPageState extends State<ShopFormPage> {
  final _formKey = GlobalKey<FormState>();

  // --- Controllers for all text fields ---
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _thumbnailController = TextEditingController(); // <-- NEW
  final _brandController = TextEditingController(); // <-- NEW
  final _stockController = TextEditingController(); // <-- NEW
  final _ratingController = TextEditingController(); // <-- NEW
  final _otherCategoryController = TextEditingController(); // <-- NEW

  // --- State variables for dropdown and checkbox ---
  final List<String> _categories = ['Shoes', 'Apparel', 'Hardware', 'Balls', 'Others'];
  String _selectedCategory = 'Shoes'; // <-- NEW: Default value
  bool _isFeatured = false; // <-- NEW: Default value

  bool _submitting = false;

  // Django endpoint you added earlier
  static const String createProductUrl =
      'http://localhost:8000/create-product-flutter/'; // OK for Chrome (desktop)

  @override
  void dispose() {
    // Clean up all controllers
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose(); // <-- NEW
    _brandController.dispose(); // <-- NEW
    _stockController.dispose(); // <-- NEW
    _ratingController.dispose(); // <-- NEW
    _otherCategoryController.dispose(); // <-- NEW
    super.dispose();
  }

  void _resetForm() {
    // Helper function to clear all inputs and reset state
    _formKey.currentState?.reset();
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _thumbnailController.clear();
    _brandController.clear();
    _stockController.clear();
    _ratingController.clear();
    _otherCategoryController.clear();
    setState(() {
      _isFeatured = false;
      _selectedCategory = _categories.first;
    });
  }

  Future<void> _submitToServer(CookieRequest request) async {
    // Validate first
    final form = _formKey.currentState!;
    if (!form.validate()) return;

    setState(() => _submitting = true);

    // Prepare final category
    String finalCategory = _selectedCategory;
    if (_selectedCategory == 'Others') {
      finalCategory = _otherCategoryController.text.trim();
    }

    // Parse ints safely
    final int price = int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0;
    final int stock = int.tryParse(_stockController.text) ?? 0;
    final String rating = _ratingController.text.trim();

    final payload = {
      "name": _nameController.text.trim(),
      "price": price,
      "description": _descriptionController.text.trim(),
      "thumbnail": _thumbnailController.text.trim(),
      "category": finalCategory,
      "category_other": null,
      "is_featured": _isFeatured,
      "stock": stock,
      "rating": rating,
      "brand": _brandController.text.trim(),
    };

    try {
      // pbp_django_auth's postJson accepts (url, body) where body is a JSON string
      final response = await request.postJson(createProductUrl, jsonEncode(payload));

      // response might already be decoded Map or a String -> handle both
      dynamic data = response;
      if (data is String) {
        data = json.decode(data);
      }

      if (data is Map && data['status'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product successfully created!')),
        );

        // Reset the form locally
        _resetForm();

        // Navigate to product list page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductEntryListPage()),
        );
      } else {
        final message = (data is Map && data['message'] != null)
            ? data['message'].toString()
            : 'Something went wrong, please try again.';
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        }
      }
    } catch (e) {
      // Show error details
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting product: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Attach CookieRequest from Provider so the page can POST with session cookies
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Name Field ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Product Name',
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Price Field ---
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  hintText: 'Product Price',
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Price cannot be empty!';
                  }
                  if (int.tryParse(value.replaceAll(',', '')) == null) {
                    return 'Price must be a valid number!';
                  }
                  if (int.parse(value.replaceAll(',', '')) <= 0) {
                    return 'Price must be greater than zero!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Description Field ---
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Product Description',
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Description cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Thumbnail Link Field ---
              TextFormField(
                controller: _thumbnailController,
                decoration: const InputDecoration(
                  hintText: 'e.g., https://example.com/image.png',
                  labelText: 'Thumbnail URL',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.url,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Thumbnail URL cannot be empty!';
                  }
                  final uri = Uri.tryParse(value);
                  if (uri == null || !uri.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Brand Field ---
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Nike, Adidas',
                  labelText: 'Brand',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Brand cannot be empty!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Stock Field ---
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(
                  hintText: 'e.g., 100',
                  labelText: 'Stock',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Stock cannot be empty!';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Stock must be a valid number!';
                  }
                  if (int.parse(value) < 0) {
                    return 'Stock cannot be negative!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Rating Field ---
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  hintText: 'e.g., 4.5 or 5.0',
                  labelText: 'Rating (0.0 - 5.0)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Allow 0-5 with optional single decimal
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-5](\.\d{0,1})?$')),
                ],
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Rating cannot be empty!';
                  }
                  final double? rating = double.tryParse(value);
                  if (rating == null) {
                    return 'Rating must be a valid number!';
                  }
                  if (rating < 0.0 || rating > 5.0) {
                    return 'Rating must be between 0.0 and 5.0!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Category Dropdown ---
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category!';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Conditional "Other Category" Field ---
              if (_selectedCategory == 'Others')
                TextFormField(
                  controller: _otherCategoryController,
                  decoration: const InputDecoration(
                    hintText: 'Please specify category',
                    labelText: 'Other Category',
                    border: OutlineInputBorder(),
                  ),
                  validator: (String? value) {
                    // Only validate if 'Others' is selected
                    if (_selectedCategory == 'Others' && (value == null || value.isEmpty)) {
                      return 'Please specify the category!';
                    }
                    return null;
                  },
                ),

              if (_selectedCategory == 'Others') const SizedBox(height: 16.0),

              // --- "Is Featured" Checkbox ---
              CheckboxListTile(
                title: const Text('Is Featured?'),
                subtitle: const Text('Feature this item on the main page'),
                value: _isFeatured,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isFeatured = newValue ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24.0),

              // --- Save Button (with Gradient) ---
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFa855f7), // Purple
                      Color(0xFFd946ef), // Fuchsia
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _submitting
                      ? null
                      : () {
                          // Submit form to Django using CookieRequest
                          _submitToServer(request);
                        },
                  child: _submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
