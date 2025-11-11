// lib/animated_gradient_text.dart
import 'package:flutter/material.dart';

class AnimatedGradientText extends StatefulWidget {
  const AnimatedGradientText({super.key});

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Matches your CSS animation
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            // Recreate the CSS gradient: (fuchsia, cyan, fuchsia)
            // We animate the 'transform' to simulate the background-position shift
            return LinearGradient(
              colors: const [
                Color(0xFFFF00FF), // fuchsia
                Color(0xFF00FFFF), // cyan
                Color(0xFFFF00FF), // fuchsia
              ],
              stops: const [0.0, 0.5, 1.0],
              // Animate the gradient's position
              transform: GradientRotation(_animation.value * 2 * 3.14159),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: const Row(
        mainAxisSize: MainAxisSize.min, // Important for AppBar title
        children: [
          Text(
            'Sports ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This color is masked,
            ),
          ),
          Text(
            'Universe',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white, // This color is masked
            ),
          ),
        ],
      ),
    );
  }
}