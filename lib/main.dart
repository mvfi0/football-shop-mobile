// lib/main.dart
import 'package:flutter/material.dart';
import 'menu.dart';

void main() {
  runApp(const FootballShopApp());
}

class FootballShopApp extends StatelessWidget {
  const FootballShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Universe', // <-- 1. RENAMED
      theme: ThemeData(
        // --- 2. SET DARK GALAXY THEME ---
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6d28d9), // Purple
        scaffoldBackgroundColor: const Color(0xFF110025), // Dark purple bg
        
        // Define a color scheme for the dark theme
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFa855f7), // Purple
          secondary: Color(0xFFd946ef), // Fuchsia
          background: Color(0xFF110025), // Dark purple bg
          onBackground: Color(0xFFf3e8ff), // Light text
          error: Colors.redAccent,
        ),
        
        // Style AppBars
        appBarTheme: const AppBarTheme(
          // We'll use flexibleSpace for gradients, so a base color is fine
          backgroundColor: Color(0xFF110025), 
          foregroundColor: Colors.white,
          elevation: 0,
        ),

        // Style TextFormFields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black.withOpacity(0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xFFd946ef)), // Fuchsia
          ),
          labelStyle: const TextStyle(color: Color(0xFFf3e8ff)),
        ),
      ),
      home: const MenuScreen(),
    );
  }
}