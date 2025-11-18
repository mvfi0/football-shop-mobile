// lib/screens/product_entry_list.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:football_shop/models/product_entry.dart';
import 'package:football_shop/widgets/product_entry_card.dart';
import 'package:football_shop/screens/product_detail.dart';
import 'package:football_shop/widgets/left_drawer.dart'; // remove if you don't have this widget
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductEntryListPage extends StatefulWidget {
  const ProductEntryListPage({super.key});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  // Use the JSON endpoint that returned JSON in your browser
  static const String productListUrl = 'http://localhost:8000/json/';

  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    try {
      final response = await request.get(productListUrl);

      // Debug info
      debugPrint('fetchProducts response runtimeType: ${response.runtimeType}');

      dynamic data = response;

      if (data is String) {
        final trimmed = data.trimLeft();

        // detect HTML (login page or error page) to give a clearer error
        if (trimmed.startsWith('<')) {
          final snippet = trimmed.length > 300 ? trimmed.substring(0, 300) : trimmed;
          throw FormatException(
            'Server returned HTML instead of JSON. Open $productListUrl in a browser to inspect. Snippet: $snippet'
          );
        }

        data = json.decode(data);
      }

      if (data is! List) {
        throw FormatException('Expected a JSON array but got ${data.runtimeType}');
      }

      final list = <ProductEntry>[];
      for (var d in data) {
        if (d != null) {
          // ensure we have a Map<String, dynamic>
          list.add(ProductEntry.fromJson(Map<String, dynamic>.from(d)));
        }
      }
      return list;
    } catch (e, st) {
      debugPrint('fetchProducts error: $e\n$st');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder<List<ProductEntry>>(
        future: fetchProducts(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Show a friendly error UI. FormatException messages include a helpful snippet if the server returned HTML.
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final products = snapshot.data ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return ProductEntryCard(
                product: p,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProductScreen(product: p),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
