import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Shop Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // All Products Button (Blue)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              icon: const Icon(Icons.list),
              label: const Text("All Products"),
              onPressed: () {
                showSnackbar(context, "You have pressed the All Products button");
              },
            ),

            const SizedBox(height: 15),

            // My Products Button (Green)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              icon: const Icon(Icons.inventory),
              label: const Text("My Products"),
              onPressed: () {
                showSnackbar(context, "You have pressed the My Products button");
              },
            ),

            const SizedBox(height: 15),

            // Create Product Button (Red)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              icon: const Icon(Icons.add),
              label: const Text("Create Product"),
              onPressed: () {
                showSnackbar(context, "You have pressed the Create Product button");
              },
            ),
          ],
        ),
      ),
    );
  }
}
