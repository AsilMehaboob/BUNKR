import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'profile_menu_item.dart';

class ProfileDropdown extends StatelessWidget {
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? user;

  const ProfileDropdown({super.key, 
    this.profile,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final avatarAsset = 'lib/assets/avatars/user.png';

    return PopupMenuButton(
      color: const Color(0xFF1E1E1E), // Background color
      elevation: 0, // Remove shadow
      offset: const Offset(0, 10),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide.none, // Remove border
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Container(
            color: const Color(0xFF1E1E1E),
            child: Column(
              children: [
                ProfileMenuItem(
                  icon: Icons.logout,
                  label: 'Log Out',
                  onTap: () {
                    AuthService().logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(backgroundImage: AssetImage(avatarAsset)),
      ),
    );
  }
}