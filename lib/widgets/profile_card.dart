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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: 240, // Reduced from 260
            maxHeight: MediaQuery.of(context).size.height * 0.3, // Reduced from 0.5
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF1E1E1E),
          ),
          child: Stack(
            children: [
              // Gray background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 90, // Reduced from 100
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16)),
                  ),
                ),
              ),
              // Main content
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 20), // Reduced padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 45, // Reduced from 50
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage('lib/assets/avatars/user.png'),
                        ),
                      ),
                      const SizedBox(height: 30), // Reduced from 40
                      // Text section
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                fullName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6), // Reduced from 8
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}