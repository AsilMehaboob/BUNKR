import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_bar.dart';
import '../widgets/profile_card.dart'; // Add this import

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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 24),
              child: ProfileCard( // Updated widget usage
                userData: userData,
                profileData: profileData,
              ),
            );
          },
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