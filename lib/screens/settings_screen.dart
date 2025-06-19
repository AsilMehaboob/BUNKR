import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/profile_service.dart';
import '../widgets/appbar/app_bar.dart';
import '../widgets/settings/tabs.dart';
import '../widgets/settings/profile_card.dart';
import '../widgets/settings/target_percentage_dropdown.dart';
import '../services/settings_service.dart';

class ProfileScreen extends StatefulWidget {
  final SettingsService settingsService;

  const ProfileScreen({super.key, required this.settingsService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final ProfileService _profileService = ProfileService();
  late int _targetPercentage;
  
  @override
  void initState() {
    super.initState();
    _targetPercentage = widget.settingsService.targetPercentageNotifier.value;
  }

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
                    
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Target Attendance:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TargetPercentageDropdown(
                            selectedPercentage: _targetPercentage,
                            onChanged: (newPercentage) async {
                              await widget.settingsService.setTargetPercentage(newPercentage);
                              setState(() => _targetPercentage = newPercentage);
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                      child: Opacity(
                        opacity: 0.8,
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: 'DMMono', 
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
                                  color: Color(0xFFF90D2A),
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