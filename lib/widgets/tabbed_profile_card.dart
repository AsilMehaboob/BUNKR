// widgets/tabbed_profile_card.dart
import 'package:flutter/material.dart';
import '../services/profile_service.dart';
import '../services/user_service.dart';

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
      color: Colors.grey[900],
      margin: const EdgeInsets.only(top: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTabBar(),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
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
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueAccent,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Account'),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextFormField(
            controller: _firstNameController,
            enabled: _isEditing && !_isUpdating,
            decoration: _inputDecoration('First Name'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _lastNameController,
            enabled: _isEditing && !_isUpdating,
            decoration: _inputDecoration('Last Name'),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: _inputDecoration('Gender'),
            items: const [
              DropdownMenuItem(value: 'male', child: Text('Male')),
              DropdownMenuItem(value: 'female', child: Text('Female')),
            ],
            onChanged: _isEditing && !_isUpdating
                ? (value) => setState(() => _gender = value!)
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            enabled: _isEditing && !_isUpdating,
            controller: TextEditingController(text: _birthDate),
            decoration: _inputDecoration('Birth Date'),
            onTap: _isEditing ? _selectDate : null,
          ),
          const SizedBox(height: 24),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        _buildAccountInfo('Username', '@${widget.userData['username']}'),
        _buildAccountInfo('Email', widget.userData['email']),
        _buildAccountInfo('Mobile', '+${widget.userData['mobile']}'),
        _buildAccountInfo(
          'Account Created',
          DateTime.parse(widget.userData['created_at'])
              .toLocal()
              .toString()
              .split(' ')[0],
        ),
      ],
    );
  }

  Widget _buildAccountInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[400])),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
                child: OutlinedButton(
                  onPressed: _cancelEditing,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
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