import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'notification_dropdown.dart';
import 'profile_dropdown.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthService authService = AuthService();
  
  CustomAppBar({super.key});

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
        // Notification Dropdown with right padding
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: FutureBuilder<List<dynamic>>(
            future: authService.client.get('/Xcr45_salt/user/notifications')
                .then((res) => res.data as List<dynamic>),
            builder: (context, snapshot) {
              final unreadCount = snapshot.hasData ? snapshot.data!.length : 0;
              return NotificationDropdown(
                unreadCount: unreadCount,
                notifications: snapshot.hasData ? snapshot.data! : [],
              );
            },
          ),
        ),
        
        // Profile Dropdown with left padding
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