import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;
  final TextStyle? textStyle;
  final double? iconSize;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color.fromARGB(255, 255, 0, 0),
    this.textStyle,
    this.iconSize = 22.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                weight: 700,
                size: iconSize,
              ),
              const SizedBox(width: 12.0),
              Text(
                label,
                style: textStyle ??
                    TextStyle(
                        color: color,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
