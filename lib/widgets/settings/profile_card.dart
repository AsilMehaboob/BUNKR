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
            '${profileData['last_name'] ?? ''}'
        .trim();
    final username = '@${userData['username'] ?? 'username'}';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color.fromRGBO(158, 158, 158, 0.2),
                    width: 3,
                  ),
                ),
                child: const CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage('assets/images/cat.png'),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                fullName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                username.toLowerCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
