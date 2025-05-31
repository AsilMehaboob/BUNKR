import 'package:flutter/material.dart';

class StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatBlock({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 58,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Vertical centering
          crossAxisAlignment: CrossAxisAlignment.center, // Horizontal centering
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}