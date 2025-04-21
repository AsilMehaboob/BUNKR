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
      backgroundColor: Colors.black,
      title: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Color(0xFF6CA2AB),
              Color(0xFFB0CBCA),
              Color(0xFFCCD9D6),
              Color(0xFFEDBEA2),
            ],
            stops: [0.0, 0.35, 0.65, 1.0],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: const Text(
          'bunkr',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        FutureBuilder<List<dynamic>>(
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
        FutureBuilder<Map<String, dynamic>>(
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}