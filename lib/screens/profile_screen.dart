import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../widgets/app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isEditing = false;
  bool _isLoading = true;
  late Map<String, dynamic> _profileData;
  late Map<String, dynamic> _userData;
  String? _selectedInstitution;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
  final authService = AuthService();
  final profileResponse = await authService.client.get('/myprofile');
  final userResponse = await authService.client.get('/user');

  print('✅ Profile: ${profileResponse.data}');
  print('✅ User: ${userResponse.data}');

  setState(() {
    _profileData = profileResponse.data;
    _userData = userResponse.data;
    _initializeFormData();
    _isLoading = false;
  });
} catch (e, stack) {
  print('❌ Failed to load profile data: $e');
  print(stack);
}


  }

  void _initializeFormData() {
    _firstNameController.text = _profileData['first_name'] ?? '';
    _lastNameController.text = _profileData['last_name'] ?? '';
    _genderController.text = _profileData['gender'] ?? 'male';
    _dobController.text = _profileData['birth_date'] ?? '';
    _selectedInstitution = _userData['settings']['default_institute'] ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = AuthService();
        await authService.client.put(
          '/userprofiles/${_profileData['id']}',
          data: {
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text,
            'gender': _genderController.text,
            'birth_date': _dobController.text,
          },
        );
        setState(() => _isEditing = false);
      } catch (e) {
        // Handle error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserCard(),
            const SizedBox(height: 24),
            _buildInstitutionCard(),
            const SizedBox(height: 24),
            _buildTabBar(),
            _buildTabContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: _profileData['profile_image'] != null
                ? NetworkImage(_profileData['profile_image'])
                : const AssetImage('assets/default_avatar.png') as ImageProvider,
          ),
          const SizedBox(height: 16),
          Text(
            '${_profileData['first_name']} ${_profileData['last_name']}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '@${_userData['username']}',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstitutionCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'institutions',
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedInstitution,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF1A1A1A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.school, color: Colors.grey),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ),
            items: const [
              DropdownMenuItem(
                value: 'govt. model engineering college',
                child: Text('govt. model engineering college'),
              ),
            ],
            onChanged: (value) => setState(() => _selectedInstitution = value),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800],
              minimumSize: const Size(160, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Save as Default'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF1E1E1E),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[400],
        tabs: const [
          Tab(text: 'personal'),
          Tab(text: 'account'),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalTab(),
          _buildAccountTab(),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'personal information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildFormField('First Name', _firstNameController),
            const SizedBox(height: 16),
            _buildFormField('Last Name', _lastNameController),
            const SizedBox(height: 16),
            _buildGenderDropdown(),
            const SizedBox(height: 16),
            _buildDateField(),
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    _saveProfile();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? Colors.green : Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  _isEditing ? 'Save Changes' : 'Edit Profile',
                  style: TextStyle(
                    color: _isEditing ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'account settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _buildAccountInfoField('Username', _userData['username']),
          const SizedBox(height: 16),
          _buildAccountInfoField('Email', _userData['email']),
          const SizedBox(height: 16),
          _buildAccountInfoField('Mobile', _userData['mobile']),
          const SizedBox(height: 16),
          _buildAccountInfoField(
            'Account Created',
            DateFormat('dd/MM/yyyy').format(
              DateTime.parse(_userData['created_at']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: _isEditing,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _genderController.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'male', child: Text('Male')),
        DropdownMenuItem(value: 'female', child: Text('Female')),
      ],
      onChanged: _isEditing
          ? (value) => setState(() => _genderController.text = value!)
          : null,
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dobController,
      enabled: _isEditing,
      readOnly: true,
      onTap: _isEditing ? () => _selectDate(context) : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
      ),
    );
  }

  Widget _buildAccountInfoField(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}