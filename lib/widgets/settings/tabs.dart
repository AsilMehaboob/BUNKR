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
    if (widget.profileData['birth_date'] != null) {
      _birthDate = DateTime.tryParse(widget.profileData['birth_date']);
    } else {
      _birthDate = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: CupertinoSlidingSegmentedControl<String>(
            groupValue: _currentTab,
            onValueChanged: (String? value) {
              if (value != null) {
                setState(() => _currentTab = value);
              }
            },
            children: const {
              'personal': Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Personal',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              'account': Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Account',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            },
            backgroundColor: const Color(0xFF313131), // Custom background color
            thumbColor: Colors.black,
          ),
        ),
        _currentTab == 'personal' ? _buildPersonalCard() : _buildAccountCard(),
      ],
    );
  }

  Widget _buildPersonalCard() {
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0x60313131),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0x80313131),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(
                bottom: BorderSide(
                    color: Color(0xFF212121)), // or Colors.grey.shade900
              ),
            ),
            child: Center(
              child: Text(
                'Personal Information',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: 17,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadInputFormField(
                  label: Text('First Name',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          )),
                  controller: _firstNameController,
                  enabled: _isEditing && !_isUpdating,
                ),
                const SizedBox(height: 15),
                ShadInputFormField(
                  label: Text('Last Name',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          )),
                  controller: _lastNameController,
                  enabled: _isEditing && !_isUpdating,
                ),
                const SizedBox(height: 15),
                _buildGenderDropdown(),
                const SizedBox(height: 15),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Container(
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0x60313131),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade900),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0x80313131),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              border: const Border(
                bottom: BorderSide(
                    color: Color(0xFF212121)), // or Colors.grey.shade900
              ),
            ),
            child: Center(
              child: Text(
                'Account Information',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color.fromRGBO(255, 255, 255, 0.6),
                      fontSize: 17,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadInputFormField(
                  label: Text('Username',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          )),
                  initialValue: '@${widget.userData['username']}'.toLowerCase(),
                  enabled: false,
                ),
                const SizedBox(height: 15),
                ShadInputFormField(
                  label: Text('Email',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          )),
                  initialValue: widget.userData['email'],
                  enabled: false,
                ),
                const SizedBox(height: 15),
                ShadInputFormField(
                  label: Text('Mobile',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          )),
                  initialValue: '+${widget.userData['mobile']}',
                  enabled: false,
                ),
                const SizedBox(height: 15),
                ShadInputFormField(
                  label: Text('Account Created',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 13,
                          )),
                  initialValue: DateTime.parse(widget.userData['created_at'])
                      .toLocal()
                      .toString()
                      .split(' ')[0],
                  enabled: false,
                ),
              ],
            ),
          ),
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
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 7),
        ShadSelectFormField<String>(
          id: 'gender',
          minWidth: 150,
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
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          width: double.infinity,
          height: 38,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isEditing && !_isUpdating
                  ? Colors.grey.shade900
                  : const Color.fromARGB(146, 33, 33, 33),
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: ShadButton.outline(
            onPressed: _isEditing && !_isUpdating
                ? () => _showDatePickerDialog(context)
                : null,
            decoration: const ShadDecoration(
              border: ShadBorder.none,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    _birthDate != null
                        ? '${_birthDate!.day.toString().padLeft(2, '0')}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.year}'
                        : 'Select Birth Date',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: _isEditing && !_isUpdating
                          ? Colors.white
                          : Colors
                              .grey.shade700, // Lighter color when not selected
                    ),
                  ),
                ],
              ),
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
                decoration: const ShadDecoration(
                  border: ShadBorder(
                    radius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ShadButton(
                onPressed: _submitForm,
                decoration: const ShadDecoration(
                  border: ShadBorder(
                    radius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(width: 12),
              ShadButton(
                onPressed: () => setState(() => _isEditing = true),
                decoration: const ShadDecoration(
                  border: ShadBorder(
                    radius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
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
      final sonner = ShadSonner.of(context);
      sonner.show(
        ShadToast(
          id: DateTime.now().millisecondsSinceEpoch,
          title: const Text('Profile Updated'),
          description: const Text('Your profile changes have been saved'),
        ),
      );
    } catch (e) {
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
