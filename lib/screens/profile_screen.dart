import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_bar.dart';

class ProfileScreen extends StatelessWidget {
  final UserService _userService = UserService();
  final ProfileService _profileService = ProfileService();

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            _userService.fetchUserProfile(),
            _profileService.fetchProfile(),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState(snapshot.error);
            }

            final userData = snapshot.data![0] as Map<String, dynamic>;
            final profileData = snapshot.data![1] as Map<String, dynamic>;

            return Center(
              child: _buildProfileCard(context, userData, profileData),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    Map<String, dynamic> userData,
    Map<String, dynamic> profileData,
  ) {
    return Card(
      color: const Color(0xFF1E1E1E),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        width: MediaQuery.of(context).size.width * 0.6,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('lib/assets/avatars/user.png'),
              onBackgroundImageError: (exception, stackTrace) =>
                  const AssetImage('lib/assets/avatars/user.png'),
            ),
            const SizedBox(height: 20),
            Text(
              '${profileData['first_name'] ?? ''} '
              '${profileData['last_name'] ?? ''}'.trim(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '@${userData['username'] ?? 'username'}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            'Failed to load profile: ${error ?? 'Unknown error'}',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}