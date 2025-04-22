import 'package:flutter/material.dart';
import 'dart:math' as math;

class LineLoadingAnimation extends StatefulWidget {
  const LineLoadingAnimation({super.key});

  @override
  State<LineLoadingAnimation> createState() => _LineLoadingAnimationState();
}

class _LineLoadingAnimationState extends State<LineLoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int lineCount = 6;
  final double size = 35.0;
  final double stroke = 3.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLine(int index) {
    final double opacity = 1.0 - (index * 0.2);
    final double delay = -0.375 + (index * 0.075); // sync with CSS delays

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        // Simulate staggered animation via phase shift
        double progress = (_controller.value + delay) % 1.0;
        double angle = math.pi * progress;

        return Transform.rotate(
          angle: angle,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              height: stroke,
              width: size,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(opacity.clamp(0.0, 1.0)),
                borderRadius: BorderRadius.circular(stroke / 2),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(lineCount, (i) => _buildLine(i)),
      ),
    );
  }
}
