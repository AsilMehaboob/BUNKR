import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/profile_service.dart';
import '../widgets/appbar/app_bar.dart';
import '../widgets/account/tabs.dart';
import '../widgets/account/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final ProfileService _profileService = ProfileService();
  
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
          builder: (context, snapshot) {
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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    ProfileCard(
                      userData: userData,
                      profileData: profileData,
                    ),
                    const SizedBox(height: 24),
                    TabbedProfileCard(userData: userData, profileData: profileData),
                    
                    // --- UPDATED FOOTER WITH DM MONO FONT ---
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                      child: Opacity(
                        opacity: 0.8,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'DMMono', // Use DM Mono font
                            ),
                            children: [
                              TextSpan(
                                text: 'built by',
                                style: TextStyle(
                                  color: Colors.grey[600]!.withOpacity(0.88),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const TextSpan(
                                text: ' ',
                              ),
                              TextSpan(
                                text: 'zero-day',
                                style: const TextStyle(
                                  color: Color(0xFFF90D2A), // Red color from React example
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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