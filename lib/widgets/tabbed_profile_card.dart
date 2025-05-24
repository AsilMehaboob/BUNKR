// widgets/tabbed_profile_card.dart
import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class TabbedProfileCard extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> profileData;

  const TabbedProfileCard({
    super.key,
    required this.userData,
    required this.profileData,
  });

  @override
  State<TabbedProfileCard> createState() => _TabbedProfileCardState();
}

class _TabbedProfileCardState extends State<TabbedProfileCard>
    with SingleTickerProviderStateMixin {
  // Color Constants
  static const primaryBackground = Color(0xFF1E1E1E);
  static const primaryText = Color(0xFFE0E0E0);
  static const secondaryText = Color(0xFFAAAAAA);
  static const inputBackground = Color(0xFF222222);
  static const selectedTabBg = Color(0xFF333333);
  static const unselectedTabText = Color(0xFF999999);
  static const buttonBg = Color(0xFFF5F5F5);
  static const buttonText = Color(0xFF333333);

  late TabController _tabController;
  late final ProfileService _profileService;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late String _gender;
  late String? _birthDate;
  bool _isEditing = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
    _tabController = TabController(length: 2, vsync: this);
    _initializeForm();
  }

  void _initializeForm() {
    _firstNameController = TextEditingController(
      text: widget.profileData['first_name'] ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.profileData['last_name'] ?? '',
    );
    _gender = widget.profileData['gender']?.toString().toLowerCase() ?? 'male';
    _birthDate = widget.profileData['birth_date'];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: primaryBackground,
      margin: const EdgeInsets.only(top: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabBar(),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildPersonalTab(),
                  _buildAccountTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: primaryBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selectedTabBg,
        ),
        labelColor: primaryText,
        unselectedLabelColor: unselectedTabText,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        isScrollable: false,
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Account'),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputField('First Name', _firstNameController),
        const SizedBox(height: 16),
        _buildInputField('Last Name', _lastNameController),
        const SizedBox(height: 16),
        _buildGenderDropdown(),
        const SizedBox(height: 16),
        _buildDateInput(),
        const Spacer(),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildAccountTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAccountInfo('Username', '@${widget.userData['username']}'),
        const SizedBox(height: 16),
        _buildAccountInfo('Email', widget.userData['email']),
        const SizedBox(height: 16),
        _buildAccountInfo('Mobile', '+${widget.userData['mobile']}'),
        const SizedBox(height: 16),
        _buildAccountInfo(
          'Account Created',
          DateTime.parse(widget.userData['created_at'])
              .toLocal()
              .toString()
              .split(' ')[0],
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: secondaryText, fontSize: 13)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: _isEditing && !_isUpdating,
          style: const TextStyle(color: primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Gender', style: TextStyle(color: secondaryText, fontSize: 13)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _gender,
          dropdownColor: inputBackground,
          style: const TextStyle(color: primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          items: const [
            DropdownMenuItem(value: 'male', child: Text('Male')),
            DropdownMenuItem(value: 'female', child: Text('Female')),
          ],
          onChanged: _isEditing && !_isUpdating
              ? (value) => setState(() => _gender = value!)
              : null,
        ),
      ],
    );
  }

  Widget _buildDateInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Birth Date', style: TextStyle(color: secondaryText, fontSize: 13)),
        const SizedBox(height: 4),
        TextFormField(
          readOnly: true,
          enabled: _isEditing && !_isUpdating,
          controller: TextEditingController(text: _birthDate),
          style: const TextStyle(color: primaryText),
          decoration: InputDecoration(
            filled: true,
            fillColor: inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14),
            suffixIcon: _isEditing
                ? const Icon(Icons.calendar_today, color: secondaryText, size: 20)
                : null,
          ),
          onTap: _isEditing ? _selectDate : null,
        ),
      ],
    );
  }

  Widget _buildAccountInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: secondaryText, fontSize: 13)),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: inputBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value, style: const TextStyle(color: primaryText)),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (_isUpdating) {
      return const Center(child: CircularProgressIndicator());
    }

    return _isEditing
        ? Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _cancelEditing,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryText,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBg,
                    foregroundColor: buttonText,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          )
        : ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBg,
              foregroundColor: buttonText,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Edit Profile'),
          );
  }


  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      filled: true,
      fillColor: Colors.grey[800],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _initializeForm();
    });
  }

  Future<void> _submitForm() async {
    setState(() => _isUpdating = true);
    try {
      await _profileService.updateProfile(
        widget.profileData['id'],
        {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'gender': _gender,
          'birth_date': _birthDate,
        },
      );
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}