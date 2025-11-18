// lib/screens/detail_product.dart
import 'package:flutter/material.dart';
import 'package:football_shop/models/product_entry.dart';
import 'package:intl/intl.dart';


class DetailProductScreen extends StatelessWidget {
  final ProductEntry product;

  const DetailProductScreen({super.key, required this.product});

  String _maybeFormatPrice(int price) {
    // simple formatting, adapt to locale if needed
    return '\$${price.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final f = product.fields;

    // Use 10.0.2.2 on Android emulator if your backend runs on localhost.
    final imageUrl =
        'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(f.thumbnail)}';

    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(f.name),
        // keep consistent with your theme
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: Colors.grey[800],
                    child: const Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title and Featured badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      f.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (f.isFeatured)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Featured',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Category / Brand row
              Row(
                children: [
                  Text(
                    'Category: ${f.category}',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Brand: ${f.brand}',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price and stock
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatter.format(f.price),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Stock: ${f.stock}',
                    style: TextStyle(color: Colors.grey[300]),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Rating (if available)
              if (f.rating.isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 6),
                    Text(f.rating),
                  ],
                ),
              if (f.rating.isNotEmpty) const SizedBox(height: 16),

              // Description
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                f.description,
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              // Action buttons (example)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: implement add-to-cart using your app logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart (demo)')),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Add to Cart'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Example: open external detail or share
                      },
                      child: const Text('Share'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
