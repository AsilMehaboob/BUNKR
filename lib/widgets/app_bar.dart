import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
        FutureBuilder<Map<String, dynamic>>(
          future: authService.client.get('/Xcr45_salt/user/notifications').then((res) => res.data),
          builder: (context, snapshot) {
            final unreadCount = snapshot.hasData ? (snapshot.data as List).length : 0;
            return _NotificationDropdown(
              unreadCount: unreadCount,
              notifications: snapshot.hasData ? (snapshot.data as List) : [],
            );
          },
        ),
        FutureBuilder<Map<String, dynamic>>(
          future: authService.client.get('/Xcr45_salt/myprofile').then((res) => res.data),
          builder: (context, profileSnapshot) {
            return FutureBuilder<Map<String, dynamic>>(
              future: authService.client.get('/Xcr45_salt/user').then((res) => res.data),
              builder: (context, userSnapshot) {
                return _ProfileDropdown(
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

class _NotificationDropdown extends StatelessWidget {
  final int unreadCount;
  final List<dynamic> notifications;

  const _NotificationDropdown({required this.unreadCount, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('$unreadCount unread', style: TextStyle(color: Colors.blue.shade800)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...notifications.take(5).map((n) => _NotificationItem(
                  title: _parseNotificationTitle(n['data']),
                  subtitle: _parseNotificationSubtitle(n['data']),
                  time: DateTime.parse(n['created_at']),
                )),
                if (notifications.isEmpty)
                  const Center(child: Text('No new notifications', style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
        ),
      ],
      child: Badge(
        label: Text(unreadCount.toString()),
        isLabelVisible: unreadCount > 0,
        child: const Icon(Icons.notifications_none, color: Colors.white),
      ),
    );
  }

  String _parseNotificationTitle(String data) {
    if (data.contains('logged in')) return 'New login detected';
    return 'System notification';
  }

  String _parseNotificationSubtitle(String data) {
    final deviceMatch = RegExp(r'unknown/unknown/(.*?)/').firstMatch(data);
    return deviceMatch?.group(1) ?? 'Unknown device';
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime time;

  const _NotificationItem({required this.title, required this.subtitle, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.security, size: 20, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                Text(
                  DateFormat('MMM dd, y • HH:mm').format(time),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDropdown extends StatelessWidget {
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? user;

  const _ProfileDropdown({this.profile, this.user});

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
                _ProfileMenuItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  onTap: () => Navigator.pushNamed(context, '/home'),
                ),
                _ProfileMenuItem(
                  icon: Icons.person,
                  label: 'Profile',
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                ),
                const Divider(height: 24),
                _ProfileMenuItem(
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

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function() onTap;
  final Color? color;

  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.grey.shade400),
      title: Text(label, style: TextStyle(color: color ?? Colors.white)),
      onTap: onTap,
    );
  }
}