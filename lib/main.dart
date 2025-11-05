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
      title: 'Football Shop',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green, foregroundColor: Colors.white),
      ),
      home: const MenuScreen(),
    );
  }
}
