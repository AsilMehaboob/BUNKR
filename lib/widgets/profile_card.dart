import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> profileData;

  const ProfileCard({
    super.key,
    required this.userData,
    required this.profileData,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = '${profileData['first_name'] ?? ''} '
        '${profileData['last_name'] ?? ''}'.trim();
    final username = '@${userData['username'] ?? 'username'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87, // dark background
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Name Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fullName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                username,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Icon Avatar
          Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 3,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 45, // Reduced from 50
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('lib/assets/avatars/user.png'),
                        ),
                      ),
        ],
      ),
    );
  }
}