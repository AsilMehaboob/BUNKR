import 'package:flutter/material.dart';
import '../../widgets/settings/profile_card.dart';
import '../../widgets/settings/tabs.dart';
import '../../services/settings_service.dart';
import 'target_attendance_dropdown.dart';
import 'built_by_footer.dart';

class ProfileBody extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> profileData;
  final SettingsService settingsService;

  const ProfileBody({
    super.key,
    required this.userData,
    required this.profileData,
    required this.settingsService,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  late int _targetPercentage;

  @override
  void initState() {
    super.initState();
    _targetPercentage = widget.settingsService.targetPercentageNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          ProfileCard(
            userData: widget.userData,
            profileData: widget.profileData,
          ),
          const SizedBox(height: 24),
          TabbedProfileCard(
            userData: widget.userData,
            profileData: widget.profileData,
          ),
          const SizedBox(height: 24),
          TargetAttendanceDropdown(
            targetPercentage: _targetPercentage,
            onChanged: (newVal) async {
              await widget.settingsService.setTargetPercentage(newVal);
              setState(() => _targetPercentage = newVal);
            },
          ),
          const SizedBox(height: 32),
          const BuiltByFooter(),
        ],
      ),
    );
  }
}
