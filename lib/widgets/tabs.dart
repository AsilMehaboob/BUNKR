import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
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

class _TabbedProfileCardState extends State<TabbedProfileCard> {
  late String _currentTab = 'personal';
  late final ProfileService _profileService;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late DateTime? _birthDate;
  late String _gender;
  bool _isEditing = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
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
    
    // Parse birth date string to DateTime
    if (widget.profileData['birth_date'] != null) {
      _birthDate = DateTime.tryParse(widget.profileData['birth_date']);
    } else {
      _birthDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadTabs<String>(
      value: _currentTab,
      onChanged: (value) => setState(() => _currentTab = value),
      tabs: [
        ShadTab(
          value: 'personal',
          child: const Text('Personal'),
          content: _buildPersonalCard(),
        ),
        ShadTab(
          value: 'account',
          child: const Text('Account'),
          content: _buildAccountCard(),
        ),
      ],
    );
  }

Widget _buildPersonalCard() {
  return ShadCard(
    title: const Text('Personal Information'),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Left-align all children
        children: [
          const SizedBox(height: 16),
          ShadInputFormField(
            label: const Text('First Name'),
            controller: _firstNameController,
            enabled: _isEditing && !_isUpdating,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: const Text('Last Name'),
            controller: _lastNameController,
            enabled: _isEditing && !_isUpdating,
          ),
          const SizedBox(height: 8),
          // Gender field with left alignment
          _buildGenderDropdown(),
          const SizedBox(height: 8),
          // Birth date with left alignment
          _buildDatePicker(),
          const SizedBox(height: 16),
          _buildActionButtons(),
        ],
      ),
    ),
  );
}

  Widget _buildAccountCard() {
    return ShadCard(
      title: const Text('Account Information'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          ShadInputFormField(
            label: const Text('Username'),
            initialValue: '@${widget.userData['username']}',
            enabled: false,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: const Text('Email'),
            initialValue: widget.userData['email'],
            enabled: false,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: const Text('Mobile'),
            initialValue: '+${widget.userData['mobile']}',
            enabled: false,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: const Text('Account Created'),
            initialValue: DateTime.parse(widget.userData['created_at'])
                .toLocal()
                .toString()
                .split(' ')[0],
            enabled: false,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
Widget _buildGenderDropdown() {
  const genderOptions = {
    'male': 'Male',
    'female': 'Female',
  };

  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Gender',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      ShadSelectFormField<String>(
        id: 'gender',
        minWidth: double.infinity, // Full width
        initialValue: _gender,
        enabled: _isEditing && !_isUpdating,
        options: genderOptions.entries
            .map((e) => ShadOption(value: e.key, child: Text(e.value)))
            .toList(),
        selectedOptionBuilder: (context, value) {
          return Text(genderOptions[value]!);
        },
        placeholder: const Text('Select Gender'),
        onChanged: (value) {
          setState(() => _gender = value!);
        },
      ),
    ],
  );
}

Widget _buildDatePicker() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Birth Date',
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        width: double.infinity, // Full width
        child: ShadDatePickerFormField(
          initialValue: _birthDate,
          enabled: _isEditing && !_isUpdating,
          onChanged: (DateTime? date) {
            setState(() => _birthDate = date);
          },
          validator: (value) {
            if (_isEditing && _birthDate == null) {
              return 'Please select a birth date';
            }
            return null;
          },
        ),
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
                child: ShadButton(
                  onPressed: _cancelEditing,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ShadButton(
                  onPressed: _submitForm,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          )
        : ShadButton(
            onPressed: () => setState(() => _isEditing = true),
            width: double.infinity,
            child: const Text('Edit Profile'),
          );
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
      // Convert DateTime to YYYY-MM-DD string
      final birthDateString = _birthDate != null
          ? "${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}"
          : null;

      await _profileService.updateProfile(
        widget.profileData['id'],
        {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'gender': _gender,
          'birth_date': birthDateString,
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
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }
}