// lib/menu.dart
import 'package:flutter/material.dart';
import 'shop_form.dart';
import 'left_drawer.dart';
import 'animated_gradient_text.dart'; // <-- 1. IMPORT ANIMATED WIDGET

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Reusable style for the buttons
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFa855f7), // Purple
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );

    return Scaffold(
      appBar: AppBar(
        title: const AnimatedGradientText(), // <-- 2. USE ANIMATED WIDGET
        centerTitle: true,
        // --- 3. ADD GRADIENT APPBAR (like Django navbar) ---
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF581c87), // Dark Indigo
                Color(0xFF6d28d9), // Purple
                Color(0xFFd946ef), // Fuchsia
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- 4. RESTYLE BUTTONS ---
            ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.list),
              label: const Text("All Products"),
              onPressed: () {},
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.inventory),
              label: const Text("My Products"),
              onPressed: () {},
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: buttonStyle,
              icon: const Icon(Icons.add),
              label: const Text("Create Product"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShopFormPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}