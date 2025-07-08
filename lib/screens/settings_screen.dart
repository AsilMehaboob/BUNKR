import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../services/user_service.dart';
import '../services/profile_service.dart';
import '../widgets/appbar/app_bar.dart';
import '../widgets/settings/tabs.dart';
import '../widgets/settings/profile_card.dart';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    ProfileCard(
                      userData: userData,
                      profileData: profileData,
                    ),
                    const SizedBox(height: 24),
                    TabbedProfileCard(
                        userData: userData, profileData: profileData),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0x60313131),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade900),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Target Attendance:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0x90424242)),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: DropdownButton2<int>(
                              value: _targetPercentage,
                              items: [75, 80, 85, 90, 95]
                                  .map((e) => DropdownMenuItem<int>(
                                        value: e,
                                        child: Text(
                                          '$e%',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (newPercentage) async {
                                if (newPercentage != null) {
                                  await widget.settingsService
                                      .setTargetPercentage(newPercentage);
                                  setState(() => _targetPercentage = newPercentage);
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color.fromARGB(144, 76, 75, 75)),
                                  color: Color.fromARGB(255, 49, 48, 48),
                                ),
                                offset: const Offset(0, -8),
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                              ),
                              underline: Container(),
                              buttonStyleData: ButtonStyleData(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                height: 40,
                                width: 90,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0, bottom: 15.0),
                        child: Opacity(
                            opacity: 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "built by ",
                                  style: TextStyle(
                                    fontFamily: 'DM_Mono',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(width: 3),
                                const Text(
                                  "zero-day",
                                  style: TextStyle(
                                    fontFamily: 'DM_Mono',
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
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
