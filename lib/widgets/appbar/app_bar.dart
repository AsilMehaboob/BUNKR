import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'profile_dropdown.dart';

import '../appbar/target_percentage_dropdown.dart'; // Add this import

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthService authService = AuthService();
  final int targetPercentage; // Add this
  final ValueChanged<int> onTargetChanged; // Add this
  
  // Update constructor
  CustomAppBar({
    super.key,
    required this.targetPercentage,
    required this.onTargetChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      title: const Text(
        'Bunkr',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      actions: [
        // Add target dropdown here
        TargetPercentageDropdown(
          selectedPercentage: targetPercentage,
          onChanged: onTargetChanged,
        ),
        const SizedBox(width: 16), // Add spacing
        
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: authService.client.get('/Xcr45_salt/myprofile').then((res) => res.data),
            builder: (context, profileSnapshot) {
              return FutureBuilder<Map<String, dynamic>>(
                future: authService.client.get('/Xcr45_salt/user').then((res) => res.data),
                builder: (context, userSnapshot) {
                  return ProfileDropdown(
                    profile: profileSnapshot.data,
                    user: userSnapshot.data,
                  );
                },
              );
            },
          ),
        ),
        
        // Add some extra space on the right edge
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}