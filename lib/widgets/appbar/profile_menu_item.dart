import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onTap;
  final Color? color;

  const ProfileMenuItem({super.key, 
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: color ?? Colors.white, // Default to white icons
      ),
      title: Text(
        label,
        style: TextStyle(color: color ?? Colors.white), // White text
      ),
      onTap: onTap,
    );
  }
}