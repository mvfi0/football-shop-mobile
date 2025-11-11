import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- NEW: For input formatters
import 'left_drawer.dart';

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
  final _brandController = TextEditingController();     // <-- NEW
  final _stockController = TextEditingController();     // <-- NEW
  final _ratingController = TextEditingController();    // <-- NEW
  final _otherCategoryController = TextEditingController(); // <-- NEW

  // --- State variables for dropdown and checkbox ---
  final List<String> _categories = ['Shoes', 'Apparel', 'Hardware', 'Balls', 'Others'];
  String _selectedCategory = 'Shoes'; // <-- NEW: Default value
  bool _isFeatured = false;           // <-- NEW: Default value

  @override
  void dispose() {
    // Clean up all controllers
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _thumbnailController.dispose(); // <-- NEW
    _brandController.dispose();     // <-- NEW
    _stockController.dispose();     // <-- NEW
    _ratingController.dispose();    // <-- NEW
    _otherCategoryController.dispose(); // <-- NEW
    super.dispose();
  }

  void _resetForm() {
    // Helper function to clear all inputs and reset state
    _formKey.currentState!.reset();
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

  @override
  Widget build(BuildContext context) {
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
                  if (int.tryParse(value) == null) {
                    return 'Price must be a valid number!';
                  }
                  if (int.parse(value) <= 0) {
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

              // --- Thumbnail Link Field --- (NEW)
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
                  // Basic URL validation
                  if (!Uri.tryParse(value)!.isAbsolute) {
                    return 'Please enter a valid URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Brand Field --- (NEW)
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

              // --- Stock Field --- (NEW)
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

              // --- Rating Field --- (NEW)
              TextFormField(
                controller: _ratingController,
                decoration: const InputDecoration(
                  hintText: 'e.g., 4.5 or 5.0',
                  labelText: 'Rating (0.0 - 5.0)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  // Regex to allow numbers 0-5, with one optional decimal place
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
                  // Check for correct format (e.g., 4.5, 5.0)
                  if (!RegExp(r'^[0-4](\.[0-9])$|^5(\.0)$|^[0-5]$').hasMatch(value)) {
                    return 'Please use format like 4.5 or 5.0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // --- Category Dropdown --- (NEW)
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

              // --- Conditional "Other Category" Field --- (NEW)
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
              
              if (_selectedCategory == 'Others')
                const SizedBox(height: 16.0),


              // --- "Is Featured" Checkbox --- (NEW)
              CheckboxListTile(
                title: const Text('Is Featured?'),
                subtitle: const Text('Feature this item on the main page'),
                value: _isFeatured,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isFeatured = newValue ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading, // Checkbox on the left
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
                    foregroundColor: Colors.white, // <-- ADD THIS LINE
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // (Your existing onPressed logic goes here)
                    final form = _formKey.currentState!;
                    if (form.validate()) {
                      // Handle 'Others' category
                      String finalCategory = _selectedCategory;
                      if (_selectedCategory == 'Others') {
                        finalCategory = _otherCategoryController.text;
                      }

                      // Show the pop-up with ALL data
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            // Style dialog to match dark theme
                            backgroundColor: const Color(0xFF1d0e30),
                            title: const Text('Product Saved'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Name: ${_nameController.text}'),
                                  Text('Price: ${_priceController.text}'),
                                  Text('Description: ${_descriptionController.text}'),
                                  Text('Thumbnail: ${_thumbnailController.text}'),
                                  Text('Brand: ${_brandController.text}'),
                                  Text('Stock: ${_stockController.text}'),
                                  Text('Rating: ${_ratingController.text}'),
                                  Text('Category: $finalCategory'),
                                  Text('Is Featured: $_isFeatured'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  _resetForm(); // Clear the form and state
                                  Navigator.of(context).pop(); // Go back to MenuScreen
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}