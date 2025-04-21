import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'profile_menu_item.dart';

class ProfileDropdown extends StatelessWidget {
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? user;

  const ProfileDropdown({
    this.profile,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final gender = profile?['gender'] ?? 'male';
    final avatarNumber = (DateTime.now().second % 6) + 1;
    final avatarAsset = 'lib/assets/avatars/${gender}_$avatarNumber.png';

    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(avatarAsset),
                ),
                const SizedBox(height: 12),
                Text(
                  user?['username'] ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(
                  user?['email'] ?? '',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ProfileMenuItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                ProfileMenuItem(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                const Divider(height: 24),
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