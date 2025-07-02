// stat_block.dart
import 'package:flutter/material.dart';

class StatBlock extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color valueColor; // New parameter for value text color

  const StatBlock({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.valueColor = Colors.white, // Default to white
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        height: 58,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w400
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: valueColor, // Use the new valueColor
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