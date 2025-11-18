// lib/widgets/left_drawer.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:football_shop/screens/login.dart'; // adjust if your login page is in a different path/name
import 'package:football_shop/screens/product_entry_list.dart';
import 'package:football_shop/shop_form.dart';
import 'package:football_shop/screens/my_products.dart';



class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  // Update this URL for Android emulator (use 10.0.2.2) or production host as needed.
  static const String logoutUrl = 'http://localhost:8000/auth/logout/';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 20)),
          ),

          // Example menu items (add/remove as needed)
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('All Products'),
            onTap: () {
              Navigator.of(context).pop(); // close drawer first
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProductEntryListPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('My Products'),
            onTap: () {
              Navigator.of(context).pop(); // close drawer

              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyProductsScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Create Product'),
            onTap: () {
              Navigator.of(context).pop(); // close drawer first
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopFormPage()),
              );
            },
          ),


          const Divider(),

          // Logout tile — uses captured navigator & scaffoldMessenger to avoid using context after await
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              // Close the drawer immediately
              Navigator.of(context).pop();

              // Capture NavigatorState & ScaffoldMessengerState BEFORE any await
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              // Read CookieRequest from provider (no rebuild needed)
              final request = context.read<CookieRequest>();

              try {
                final response = await request.logout(logoutUrl);

                // Normalize response to Map if possible
                dynamic data = response;
                if (data is String) {
                  try {
                    data = jsonDecode(data);
                  } catch (_) {
                    // keep as string if decode fails
                  }
                }

                // Evaluate success: expect a Map with 'status': True/true/'true'
                final bool success = data is Map &&
                    (data['status'] == true || data['status'] == 'True' || data['status'] == 'true');

                if (success) {
                  // data is Map here so safe to read 'message'
                  final message = (data['message'] != null) ? data['message'].toString() : 'Logged out successfully';
                  scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));

                  // Navigate to login and clear back stack
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                } else {
                  final message = (data is Map && data['message'] != null) ? data['message'].toString() : 'Logout failed';
                  scaffoldMessenger.showSnackBar(SnackBar(content: Text(message)));
                }
              } catch (e) {
                // Use captured scaffoldMessenger for error feedback
                scaffoldMessenger.showSnackBar(SnackBar(content: Text('Logout error: $e')));
              }
            },
          ),
        ],
      ),
    );
  }
}
