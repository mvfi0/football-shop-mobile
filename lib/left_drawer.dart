// lib/left_drawer.dart
import 'package:flutter/material.dart';
import 'menu.dart';
import 'shop_form.dart';
import 'animated_gradient_text.dart'; // <-- 1. IMPORT ANIMATED WIDGET

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // 2. Set dark background for the whole drawer
      backgroundColor: const Color(0xFF110025), 
      child: ListView(
        padding: EdgeInsets.zero, // Remove top padding
        children: [
          // --- 3. STYLED DRAWER HEADER ---
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF110025),
                  Color(0xFF16002b),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 4. USE ANIMATED WIDGET
                AnimatedGradientText(),
                SizedBox(height: 10),
                Text(
                  'Your one-stop shop for football gear!',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFFf3e8ff), // Light text
                  ),
                ),
              ],
            ),
          ),
          // --- 5. Style list tiles ---
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white),
            title: const Text('Home', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MenuScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart, color: Colors.white),
            title: const Text('Add Product', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopFormPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}