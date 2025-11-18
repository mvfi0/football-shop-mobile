// lib/screens/my_products.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:football_shop/models/product_entry.dart';
import 'package:football_shop/widgets/product_entry_card.dart';
import 'package:football_shop/screens/product_detail.dart';
import 'package:football_shop/widgets/left_drawer.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  int? _userId;

  // Reuse your existing endpoint
  static const String productListUrl = 'http://localhost:8000/json/';
  static const String whoamiUrl = 'http://localhost:8000/auth/whoami/';

  Future<int?> _fetchWhoAmI(CookieRequest request) async {
    final resp = await request.get(whoamiUrl);
    dynamic data = resp;
    if (data is String) data = json.decode(data);
    if (data is Map && data['is_authenticated'] == true) {
      return data['user_id'] as int?;
    }
    return null;
  }

  Future<List<ProductEntry>> _fetchAndFilter(CookieRequest request) async {
    // fetch all products (you already have this logic in ProductEntryListPage; keep DRY if you want)
    final response = await request.get(productListUrl);
    dynamic data = response;
    if (data is String) data = json.decode(data);
    if (data is! List) throw Exception('Invalid product list');

    final list = <ProductEntry>[];
    for (var d in data) {
      if (d != null) list.add(ProductEntry.fromJson(Map<String, dynamic>.from(d)));
    }

    if (_userId != null) {
      return list.where((p) => p.fields.user == _userId).toList();
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    // We will initialize _futureProducts after obtaining whoami in build (to get context)
  }

  @override
  Widget build(BuildContext context) {
    final request = Provider.of<CookieRequest>(context, listen: false);

    return FutureBuilder<int?>(
      future: _fetchWhoAmI(request),
      builder: (context, snapUser) {
        if (snapUser.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('My Products')),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapUser.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Products')),
            body: Center(child: Text('Error: ${snapUser.error}')),
          );
        }

        _userId = snapUser.data;
        if (_userId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('My Products')),
            body: const Center(child: Text('Not logged in')),
            drawer: const LeftDrawer(),
          );
        }

        // Now fetch products filtered client-side by _userId
        return Scaffold(
          appBar: AppBar(title: const Text('My Products')),
          drawer: const LeftDrawer(),
          body: FutureBuilder<List<ProductEntry>>(
            future: _fetchAndFilter(request),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Error: ${snap.error}'));
              }
              final products = snap.data ?? [];
              if (products.isEmpty) return const Center(child: Text('No products found.'));
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final p = products[i];
                  return ProductEntryCard(
                    product: p,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailProductScreen(product: p)),
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
