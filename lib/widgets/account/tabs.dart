import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../services/profile_service.dart';
import 'package:flutter/cupertino.dart';

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
        content: _buildPersonalCard(),
        child:  Text('Personal',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        ),
      ),
      ShadTab(
        value: 'account',
        content: _buildAccountCard(),
        child: Text('Account',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        )),
      ),
    ],
  );
}

Widget _buildPersonalCard() {
  return ShadCard(
    title: Text('Personal Information',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontSize: 20,

    )),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ShadInputFormField(
            label: Text('First Name',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
            controller: _firstNameController,
            enabled: _isEditing && !_isUpdating,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: Text('Last Name',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
            controller: _lastNameController,
            enabled: _isEditing && !_isUpdating,
          ),
          const SizedBox(height: 8),
          _buildGenderDropdown(),
          const SizedBox(height: 8),
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
    title: Text('Account Information',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.white,
      fontSize: 20,
    )),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // ADDED ALIGNMENT HERE
        children: [
          const SizedBox(height: 16),
          ShadInputFormField(
            label: Text('Username',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
            initialValue: '@${widget.userData['username']}',
            enabled: false,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: Text('Email',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
            initialValue: widget.userData['email'],
            enabled: false,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: Text('Mobile',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
            initialValue: '+${widget.userData['mobile']}',
            enabled: false,
          ),
          const SizedBox(height: 8),
          ShadInputFormField(
            label: Text('Account Created',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            )),
            initialValue: DateTime.parse(widget.userData['created_at'])
                .toLocal()
                .toString()
                .split(' ')[0],
            enabled: false,
          ),
          const SizedBox(height: 16),
        ],
      ),
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
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        width: double.infinity,
        child: ShadButton.outline(
          onPressed: _isEditing && !_isUpdating
              ? () => _showDatePickerDialog(context)
              : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                _birthDate != null
                    ? '${_birthDate!.day.toString().padLeft(2, '0')}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.year}'
                    : 'Select Birth Date',
                // Add conditional text color here
                style: TextStyle(
                  color: _isEditing ? null : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void _showDatePickerDialog(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: CupertinoDatePicker(
          initialDateTime: _birthDate ?? DateTime.now(),
          mode: CupertinoDatePickerMode.date,
          use24hFormat: true,
          onDateTimeChanged: (DateTime newDate) {
            setState(() => _birthDate = newDate);
          },
        ),
      ),
    ),
  );
}

Widget _buildActionButtons() {
  if (_isUpdating) {
    return const Center(child: CircularProgressIndicator());
  }

  return _isEditing
      ? Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ShadButton(
            onPressed: _cancelEditing,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          ShadButton(
            onPressed: _submitForm,
            child: const Text('Save Changes'),
          ),
        ],
      )
      : Row(  // Changed from Column to Row
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(width: 12),
            ShadButton(  // Removed width constraints
              onPressed: () => setState(() => _isEditing = true),
              child: const Text('Edit Profile'),
            ),
          ],
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
    
    // Show success toast
    final sonner = ShadSonner.of(context);
    sonner.show(
      ShadToast(
        id: DateTime.now().millisecondsSinceEpoch,
        title: const Text('Profile Updated'),
        description: const Text('Your profile changes have been saved'),
      ),
    );
  } catch (e) {
    // Show error toast
    final sonner = ShadSonner.of(context);
    sonner.show(
      ShadToast(
        id: DateTime.now().millisecondsSinceEpoch,
        title: const Text('Update Failed'),
        description: Text('Error: ${e.toString()}'),

      ),
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