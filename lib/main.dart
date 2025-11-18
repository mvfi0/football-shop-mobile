// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const FootballShopApp());
}

class FootballShopApp extends StatelessWidget {
  const FootballShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
        title: 'Sports Universe',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color(0xFF6d28d9),
          scaffoldBackgroundColor: const Color(0xFF110025),

          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFa855f7),
            secondary: Color(0xFFd946ef),
            background: Color(0xFF110025),
            onBackground: Color(0xFFf3e8ff),
            error: Colors.redAccent,
          ),

          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF110025),
            foregroundColor: Colors.white,
            elevation: 0,
          ),

          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.black26,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Color(0xFFd946ef)),
            ),
            labelStyle: TextStyle(color: Color(0xFFf3e8ff)),
          ),
        ),
        home: const LoginPage(),
      ),
    );
  }
}
